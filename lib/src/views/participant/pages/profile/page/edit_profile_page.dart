import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: ShapeDecoration(
                    image: profileController.imageBytes.value != null
                        ? DecorationImage(
                            image: MemoryImage(
                                profileController.imageBytes.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    shape: OvalBorder(),
                  ),
                  child: profileController.imageBytes.value == null
                      ? Icon(Icons.person, size: 82, color: Colors.grey[500])
                      : null,
                ),
              ),
              SizedBox(height: 28),
              Text('Name'),
              TextFormField(
                controller: profileController.nameController,
                decoration: InputDecoration(
                  hintText: profileController.userName.value,
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('Area'),
              TextFormField(
                controller: profileController.areaController,
                decoration: InputDecoration(
                  hintText: profileController.userArea.value,
                  prefixIcon: Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('Divisi'),
              TextFormField(
                controller: profileController.divisiController,
                decoration: InputDecoration(
                  hintText: profileController.userDivisi.value,
                  prefixIcon: Icon(Icons.work),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('Department'),
              TextFormField(
                controller: profileController.departmentController,
                decoration: InputDecoration(
                  hintText: profileController.userDepartment.value,
                  prefixIcon: Icon(Icons.business),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('Alamat'),
              TextFormField(
                controller: profileController.alamatController,
                decoration: InputDecoration(
                  hintText: profileController.userAlamat.value,
                  prefixIcon: Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('WhatsApp Number'),
              TextFormField(
                controller: profileController.whatsappNumberController,
                decoration: InputDecoration(
                  hintText: profileController.userWhatsapp.value,
                  prefixIcon: Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text('No KTP'),
              TextFormField(
                controller: profileController.numberKTPController,
                decoration: InputDecoration(
                  hintText: profileController.numberKtp.value,
                  prefixIcon: Icon(Icons.credit_card),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: profileController.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#72BB65"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
