import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';
import 'package:app_kopabali/src/views/loginpage/loginpage_view.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      home: LoginPageView(),
      getPages: AppPages.routes,
    ),
  );
}
