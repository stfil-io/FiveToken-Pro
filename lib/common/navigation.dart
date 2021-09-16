import 'package:fil/index.dart';
import 'package:oktoast/oktoast.dart';

class PushObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    var page = route.settings.name;
    pushAction(page: page, type: 'enter');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didRemove(route, previousRoute);
    dismissAllToast();
  }
}
