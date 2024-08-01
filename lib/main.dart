import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      home: SigninView(),
      getPages: AppPages.routes,
    ),
  );
}
