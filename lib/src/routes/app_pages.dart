import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/scan/scan_view.dart';
import 'package:app_kopabali/src/views/landingpage/authpage_view.dart';
import 'package:app_kopabali/src/views/authpage/forget_password/forgetpass_view.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';
import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/change_password_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/edit_profile_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_page.dart';
import 'package:app_kopabali/src/views/participant/participant_view.dart';
import 'package:app_kopabali/src/views/testing/testing_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.authpage,
      page: () => AuthpageView(),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => SigninView(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
    ),
    GetPage(
      name: AppRoutes.forgetpassword,
      page: () => ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.testing,
      page: () => const TestingView(),
    ),
    GetPage(name: AppRoutes.participant, page: () => ParticipantView()),
    GetPage(name: AppRoutes.committee, page: () => CommitteeView()),
    GetPage(name: AppRoutes.participant, page: () => ScanView()),
    GetPage(name: AppRoutes.editProfile, page: () => EditProfileView()),
    GetPage(name: AppRoutes.changePassword, page: () => ChangePasswordPage()),
    GetPage(name: AppRoutes.profile, page: () => ProfileParticipantPage()),
  ];
}
