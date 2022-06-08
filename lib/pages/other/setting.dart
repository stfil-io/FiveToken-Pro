import 'package:fil/index.dart';

/// setting page
class SetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetPageState();
  }
}

class SetPageState extends State<SetPage> {
  String get lang {
    return Global.langCode == 'zh' ? 'cn' : 'en';
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'set'.tr,
      hasFooter: false,
      grey: true,
      body: Padding(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  TapCard(
                    items: [
                      CardItem(
                        label: 'lang'.tr,
                        onTap: () {
                          Get.toNamed(langPage);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // TapCard(
                  //   items: [
                  //     CardItem(
                  //       label: 'notification'.tr,
                  //       onTap: () {
                  //         Get.toNamed(notificationPage);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  TapCard(
                    items: [
                      CardItem(
                        label: 'about'.tr,
                        onTap: () {
                          Get.toNamed(aboutPage);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TapCard(
                    items: [
                      CardItem(
                        label: 'clearCache'.tr,
                        onTap: () async {
                          await OpenedBox.pushInsance
                              .deleteAll(OpenedBox.pushInsance.keys);
                          await OpenedBox.messageInsance
                              .deleteAll(OpenedBox.messageInsance.keys);
                          OpenedBox.multiProposeInstance
                              .deleteAll(OpenedBox.multiProposeInstance.keys);
                          OpenedBox.multiApproveInstance
                              .deleteAll(OpenedBox.multiApproveInstance.keys);
                          showCustomToast('opSucc'.tr);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
            SafeArea(child: CommonText.grey(Global.version))
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
    );
  }
}
