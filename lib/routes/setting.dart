import 'package:fil/index.dart';
import 'package:fil/pages/other/about.dart';

List<GetPage> getSettingRoutes() {
  var list = <GetPage>[];
  var about = GetPage(name: aboutPage, page: () => AboutPage());
  list.add(about);
  return list;
}
