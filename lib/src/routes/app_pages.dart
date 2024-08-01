import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/forget_password/forgetrpass_view.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';
import 'package:app_kopabali/src/views/testing/testing_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignInView(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
    ),
    GetPage(
      name: AppRoutes.forgetpassword,
      page: () => const ForgetPassView(),
    ),
    GetPage(
      name: AppRoutes.testing,
      page: () => const TestingView(),
    ),
  ];
}
