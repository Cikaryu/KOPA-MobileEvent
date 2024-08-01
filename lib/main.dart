import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';
import 'package:app_kopabali/src/views/testing/login/login_controller.dart';
import 'package:app_kopabali/src/views/testing/login/login_view.dart';
import 'package:app_kopabali/src/views/testing/register/register_view.dart';
import 'package:app_kopabali/src/views/testing/register/register_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(
            create: (_) =>
                LoginController()), // Tambahkan provider untuk LoginController
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        home: LoginView(), // Atau LoginView() jika halaman awal adalah login
        getPages: AppPages.routes,
      ),
    ),
  );
}
