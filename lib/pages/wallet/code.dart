import 'package:fil/index.dart';
import 'package:share/share.dart';

/// display qrcode of the wallet address
class WalletCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var addr = $store.wal.addr;
    return CommonScaffold(
      title: 'rec'.tr,
      hasFooter: false,
      barColor: CustomColor.primary,
      titleColor: CustomColor.newTitle,
      background: CustomColor.primary,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Image(
          width: 20,
          image: AssetImage("images/back-w.png"),
          color: CustomColor.newTitle,
        ),
        alignment: NavLeadingAlign,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WalletQrCode(addr),
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 15, backgroundImage: AssetImage('images/logo.png')),
                  SizedBox(
                    width: 10,
                  ),
                  CommonText(
                    'STFIL Wallet',
                    color: CustomColor.newTitle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WalletQrCode extends StatelessWidget {
  final String addr;
  WalletQrCode(this.addr);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Container(
            child: Text(
              'scan'.tr,
              style: TextStyle(color: CustomColor.grey),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(vertical: 25),
          ),
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('images/border.png'))),
            child: QrImageView(addr, size: 188),
          ),
          Container(
              child: Text(
                addr,
                style: TextStyle(color: CustomColor.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.symmetric(horizontal: 34, vertical: 25)),
          Container(
            decoration: BoxDecoration(
                color: CustomColor.bgGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )),
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(width: 20, image: AssetImage('images/copy.png')),
                        SizedBox(
                          width: 5,
                        ),
                        CommonText(
                          'copy'.tr,
                          color: CustomColor.whiteTitle,
                        )
                      ],
                    ),
                    onTap: () {
                      copyText(addr);
                      showCustomToast('copyAddr'.tr);
                    },
                  ),
                ),
                Container(
                  width: 1,
                  height: 17,
                  color: CustomColor.grey,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            width: 20, image: AssetImage('images/share-d.png')),
                        SizedBox(
                          width: 5,
                        ),
                        CommonText(
                          'share'.tr,
                          color: CustomColor.whiteTitle,
                        )
                      ],
                    ),
                    onTap: () {
                      Share.share(addr);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
