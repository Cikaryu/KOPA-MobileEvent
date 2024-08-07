import 'dart:io'; // Add this line to import the 'dart:io' package

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_slide3_view.dart';

class SignupSlide2View extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _divisiController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorWhatsappController =
      TextEditingController();
  final TextEditingController _nomorKtpController = TextEditingController();

  SignupSlide2View({super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment the following line if you need to use the SignupController.
    final SignupController signupController = Get.put(SignupController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Your Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 20),
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person_2_rounded, color: Colors.grey),
                    hintText: 'Your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 10),
                Text('Area', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.location_on_sharp, color: Colors.grey),
                    hintText: 'Your Area',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your area' : null,
                ),
                SizedBox(height: 10),
                Text('Division', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _divisiController,
                  decoration: InputDecoration(
                    hintText: 'Your Division',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your division' : null,
                ),
                SizedBox(height: 10),
                Text('Department',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _departmentController,
                  decoration: InputDecoration(
                    hintText: 'Your Department',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your department' : null,
                ),
                SizedBox(height: 10),
                Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    hintText: 'Your Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                ),
                SizedBox(height: 10),
                Text('Whatsapp Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _nomorWhatsappController,
                  decoration: InputDecoration(
                    hintText: 'Your Whatsapp number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Whatsapp number'
                      : null,
                ),
                SizedBox(height: 10),
                Text('KTP Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: _nomorKtpController,
                  decoration: InputDecoration(
                    hintText: 'Your KTP number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your KTP number' : null,
                ),
                SizedBox(height: 16),
                Text('Profile Picture',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload your profile picture',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            )),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ValueListenableBuilder<File?>(
                            valueListenable: signupController.selfieImage,
                            builder: (context, value, child) {
                              return Container(
                                width: Get.width,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                  image: value != null
                                      ? DecorationImage(
                                          image: FileImage(value),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: value == null
                                    ? Icon(Icons.person,
                                        size: 100, color: Colors.grey[500])
                                    : null,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 106),
                          child: ElevatedButton(
                            onPressed: () {
                              signupController.showImageSourceDialog(
                                context,
                                'selfie',
                                signupController,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "Retake",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('KTP Picture',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                //assaddasasdasddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload your profile picture',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          )),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ValueListenableBuilder<File?>(
                          valueListenable: signupController.ktpImage,
                          builder: (context, value, child) {
                            return Container(
                              width: Get.width,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                                image: value != null
                                    ? DecorationImage(
                                        image: FileImage(value),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: value == null
                                  ? Icon(Icons.person,
                                      size: 100, color: Colors.grey[500])
                                  : null,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 106),
                        child: ElevatedButton(
                          onPressed: () {
                            signupController.showImageSourceDialog(
                              context,
                              'ktp',
                              signupController,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "Retake",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignupSlide3View()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
