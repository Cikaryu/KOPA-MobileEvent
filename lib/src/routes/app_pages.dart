import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/loginpage/loginpage_view.dart';


part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.hello,
      page: () => const LoginPageView(),
    ),
  ];
}
