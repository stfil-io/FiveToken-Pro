import 'package:fil/index.dart';
import 'package:fil/pages/other/webview.dart';
import 'package:share/share.dart';

class DrawerBody extends StatelessWidget {
  final Noop onTap;
  DrawerBody({this.onTap});
  @override
  Widget build(BuildContext context) {
    var label = $store.wal.label;
    var addr = $store.wal.addr;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                ),
                CommonText(
                  label,
                  size: 18,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  width: 10,
                ),
                Image(width: 20, image: AssetImage('images/switch.png'))
              ],
            ),
            onTap: () {
              Get.back();
              onTap();
              //Get.toNamed(walletSelectPage);
            },
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            margin: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
                color: CustomColor.bgGrey,
                borderRadius: BorderRadius.circular(5)),
            child: CommonText(
              dotString(str: addr),
              color: CustomColor.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(thickness: .2),
          DrawerItem(
            onTap: () {
              Get.back();
            },
            label: 'wallet'.tr,
            iconPath: 'wal.png',
          ),
          DrawerItem(
            onTap: () {
              Get.toNamed(setPage);
            },
            label: 'set'.tr,
            iconPath: 'setting.png',
          ),
          Spacer(),
          SizedBox(
            height: 30,
          )
        ],
      ),
      color: Colors.white,
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Noop onTap;
  final String label;
  final String iconPath;
  DrawerItem(
      {@required this.onTap, @required this.label, @required this.iconPath});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.back();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Image(width: 20, image: AssetImage('images/$iconPath')),
            SizedBox(
              width: 25,
            ),
            CommonText(
              label,
              size: 14,
              weight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
