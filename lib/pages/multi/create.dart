import 'package:fil/common/index.dart';
import 'package:fil/index.dart';
import 'package:fil/widgets/dialog.dart';

/// create a multi-sig wallet
class MultiCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MultiCreatePageState();
  }
}

class MultiCreatePageState extends State<MultiCreatePage> {
  TextEditingController labelCtrl = TextEditingController();
  TextEditingController signerCtrl = TextEditingController();
  TextEditingController thresholdCtrl = TextEditingController();
  List<TextEditingController> signers = [TextEditingController()];
  var nonceBoxInstance = OpenedBox.nonceInsance;
  int singerNum = 0;
  int nonce;
  Gas chainGas = Gas();
  @override
  void initState() {
    super.initState();
    signerCtrl.text = $store.wal.address;
    Global.provider
        .getNonceAndGas(to: FilecoinAccount.f01, method: 2, methodName: 'Exec');
  }

  String get from {
    return $store.wal.addrWithNet;
  }

  List<String> get signerAddrs {
    var signerAddrs = [from];
    signers.forEach((ctrl) {
      var s = ctrl.text.trim();
      signerAddrs.add(s);
    });
    return signerAddrs;
  }

  Future<TMessage> genMsg() async {
    var g = $store.gas.value;
    var value = '0';
    var threshold = int.parse(thresholdCtrl.text.trim());
    var params = {
      'signers': signerAddrs,
      'threshold': threshold,
      'unlock_duration': 0
    };

    /// serialize create params
    var p = await Global.provider.getSerializeParams(params);
    var msg = TMessage(
        version: 0,
        method: 2,
        nonce: $store.nonce,
        from: from,
        to: FilecoinAccount.f01,
        params: p,
        value: value,
        gasFeeCap: g.feeCap,
        gasLimit: g.gasLimit,
        gasPremium: g.premium);
    return msg;
  }

  void pushMessage(String pass) async {
    var threshold = int.parse(thresholdCtrl.text.trim());
    TMessage msg;
    try {
      msg = await genMsg();
    } catch (e) {
      showCustomError('createFail'.tr);
      return;
    }
    var wal = $store.wal;
    var private = await getPrivateKey(wal.addrWithNet, pass, wal.skKek);
    try {
      await Global.provider.sendMessage(
          message: msg,
          private: private,
          methodName: FilecoinMethod.exec,
          callback: (res) {
            OpenedBox.multiInsance.put(
                res,
                MultiSignWallet(
                    cid: res,
                    blockTime: getSecondSinceEpoch(),
                    label: labelCtrl.text.trim(),
                    threshold: threshold,
                    signers: signerAddrs));
            Get.offAllNamed(mainPage);
          });
    } catch (e) {
      print(e);
      showCustomError(getErrorMessage(e.toString()));
    }
  }

  void handleConfirm() async {
    var label = labelCtrl.text.trim();
    var threshold = thresholdCtrl.text.trim();
    var thresholdNum = 0;
    if (label == '') {
      showCustomError('enterName'.tr);
      return;
    }
    try {
      var n = int.parse(threshold);
      thresholdNum = n;
    } catch (e) {
      showCustomError('errorThreshold'.tr);
      return;
    }
    if (thresholdNum > signers.length + 1) {
      showCustomError('bigThreshold'.tr);
      return;
    }
    var allAddrValid = true;
    for (var i = 0; i < signers.length; i++) {
      var addr = signers[i].text.trim();
      if (!isValidAddress(addr)) {
        allAddrValid = false;
        break;
      }
    }
    var balanceNum = BigInt.tryParse($store.wal.balance);
    var feeNum = this.chainGas.feeNum;
    if (balanceNum <= feeNum) {
      showCustomError('errorLowBalance'.tr);
      return;
    }
    if (!allAddrValid) {
      showCustomError('errorSigner'.tr);
      return;
    }
    if (!$store.canPush) {
      var valid = await Global.provider.getNonceAndGas(
          to: FilecoinAccount.f01, method: 2, methodName: 'Exec');
      if (!valid) {
        showCustomError('errorSetGas'.tr);
        return;
      }
    }

    if ($store.wal.readonly == 1) {
      TMessage msg;
      try {
        msg = await genMsg();
      } catch (e) {
        showCustomError('createFail'.tr);
        return;
      }
      $store.setPushBackPage(mainPage);
      var cid = await Flotus.genCid(msg: jsonEncode(msg));
      Get.toNamed(mesBodyPage, arguments: {'mes': msg});
      OpenedBox.multiInsance.put(
          cid,
          MultiSignWallet(
              cid: cid,
              blockTime: getSecondSinceEpoch(),
              label: labelCtrl.text.trim(),
              threshold: int.parse(thresholdCtrl.text.trim()),
              signers: signerAddrs));
    } else {
      showPassDialog(context, (String pass) {
        pushMessage(pass);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var keyH = MediaQuery.of(context).viewInsets.bottom;
    return CommonScaffold(
      title: 'createMulti'.tr,
      footerText: 'create'.tr,
      onPressed: () {
        handleConfirm();
      },
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(12, 20, 12, keyH + 20),
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Field(
                      controller: labelCtrl,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      label: 'nameMulti'.tr,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      child: CommonText(
                        'addMultiMember'.tr,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                    CommonCard(Container(
                      height: 45,
                      padding: EdgeInsets.fromLTRB(12, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: CommonText(
                            $store.wal.address,
                            size: 16,
                          )),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText('(${'myAddr'.tr})')
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: List.generate(signers.length, (index) {
                        return Container(
                          child: Field(
                              controller: signers[index],
                              extra: Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.portrait_outlined,
                                      size: 22,
                                      color: Color.fromRGBO(0, 0, 0, .7),
                                    ),
                                    onTap: () {
                                      Get.toNamed(addressSelectPage)
                                          .then((value) {
                                        if (value != null) {
                                          signers[index].text =
                                              (value as Wallet).address;
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Get.toNamed(scanPage, arguments: {
                                          'scene': ScanScene.Address
                                        }).then((scanResult) {
                                          if (scanResult != '' &&
                                              isValidAddress(scanResult)) {
                                            signers[index].text = scanResult;
                                          }
                                        });
                                      },
                                      child: Image(
                                        width: 16,
                                        color: Colors.black,
                                        image: AssetImage('images/scan.png'),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: IconMinus,
                                    onTap: () {
                                      signers.removeAt(index);
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    width: 12,
                                  )
                                ],
                              )),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FButton(
                      text: 'addMember'.tr,
                      width: double.infinity,
                      height: 50,
                      corner: FCorner.all(6),
                      color: Colors.white,
                      onPressed: () {
                        signers.add(TextEditingController());
                        setState(() {});
                      },
                      image: Icon(Icons.add),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Field(
                      label: 'approvalNum'.tr,
                      hintText: 'lessThanMember'.tr,
                      type: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: thresholdCtrl,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() => SetGas(
                          maxFee: $store.maxFee,
                          gas: $store.chainGas,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    DocButton(
                      page: multiCreatePage,
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 120,
          )
        ],
      ),
    );
  }
}
