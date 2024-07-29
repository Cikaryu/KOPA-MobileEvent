import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/loginpage/loginpage_view.dart';
import 'package:app_kopabali/src/views/testing/testing_view.dart';


part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.hello,
      page: () => const LoginPageView(),
    ),
    GetPage(name: AppRoutes.testing, page:() => const TestingView(),)
  ];
}
