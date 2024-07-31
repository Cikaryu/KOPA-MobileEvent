import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/loginpage/loginpage_view.dart';
import 'package:app_kopabali/src/views/participant/participant_view.dart';
import 'package:app_kopabali/src/views/testing/register/register_view.dart';
import 'package:app_kopabali/src/views/testing/scanqr/testing_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPageView(),
    ),
    GetPage(
      name: AppRoutes.testing,
      page: () => const TestingView(),
    ),
    GetPage(
      name: AppRoutes.participant,
      page: () => ParticipantView(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
    ),
  ];
}
