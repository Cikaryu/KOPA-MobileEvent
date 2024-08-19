import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';

class HomePageCommittee extends StatelessWidget {
  const HomePageCommittee({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return Center(
      child: Column(
        children: [
          Text('Home Page',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await profileController.logout();
            },
          ),
        ],
      ),
    );
  }
}
