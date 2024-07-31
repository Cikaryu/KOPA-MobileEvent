import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/auth_view.dart';
import 'package:app_kopabali/src/views/testing/testing_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.hello,
      page: () => const AuthPageView(),
    ),
    GetPage(
      name: AppRoutes.testing,
      page: () => const TestingView(),
    )
  ];
}
