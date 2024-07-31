// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:app_kopabali/src/core/base_import.dart';
import 'auth_controller.dart';

class AuthPageView extends StatelessWidget {
  const AuthPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageController>(
      init: LoginPageController(),
      builder: (controller) => Scaffold(
        body: PageView.builder(
          itemCount: 2,
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: controller.PageItemBuilder,
        ),
      ),
    );
  }
}
