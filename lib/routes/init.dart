import 'package:fil/index.dart';

List<GetPage> getInitRoutes() {
  var list = <GetPage>[];
  var wallet = GetPage(
      name: initWalletPage,
      page: () => WalletInitPage(),
      transition: Transition.fadeIn);
  // var wallet = GetPage(name: initWalletPage, page: () => WalletInitPage());
  // var mode = GetPage(name: initModePage, page: () => WalletModePage());
  list..add(wallet);
  return list;
}
