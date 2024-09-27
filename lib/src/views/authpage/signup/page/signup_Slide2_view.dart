import 'dart:io'; // Add this line to import the 'dart:io' package
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:flutter/services.dart';

class SignupSlide2View extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignupSlide2View({super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment the following line if you need to use the SignupController.
    final SignupController signupController = Get.put(SignupController());
    // final TextEditingController nameController =
    //     TextEditingController(text: signupController.nameController.text);
    // final TextEditingController areaController =
    //     TextEditingController(text: signupController.areaController.text);
    // final TextEditingController divisionController =
    //     TextEditingController(text: signupController.divisionController.text);
    // final TextEditingController departmentController =
    //     TextEditingController(text: signupController.departmentController.text);
    // final TextEditingController addressController =
    //     TextEditingController(text: signupController.addressController.text);
    // final TextEditingController whatsappNumberController =
    //     TextEditingController(
    //         text: signupController.whatsappNumberController.text);
    // final TextEditingController ktpNumberController =
    //     TextEditingController(text: signupController.ktpNumberController.text);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              signupController.backPage();
            },
          ),
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
                  controller: signupController.nameController,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9,. ]')),
                  ],
                ),
                SizedBox(height: 10),
                Text('Area', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.areaController,
                  decoration: InputDecoration(
                    hintText: 'Your Area',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your area' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9,. ]')),
                  ],
                ),
                SizedBox(height: 10),
                Text('Division', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.divisionController,
                  decoration: InputDecoration(
                    hintText: 'Your Division',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your division' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9,. ]')),
                  ],
                ),
                SizedBox(height: 10),
                Text('Department',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.departmentController,
                  decoration: InputDecoration(
                    hintText: 'Your Department',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your department' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9,. ]')),
                  ],
                ),
                SizedBox(height: 10),
                Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.addressController,
                  decoration: InputDecoration(
                    hintText: 'Your Address',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9,. ]')),
                  ],
                ),
                SizedBox(height: 10),
                Text('Whatsapp Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.whatsappNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  decoration: InputDecoration(
                    hintText: 'Example : 08123xxxxxxx',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Whatsapp number';
                    } else if (value.length < 10) {
                      return 'Whatsapp number must be at least 10 digits';
                    } else if (value.length > 13) {
                      return 'Whatsapp number must not exceed 13 digits';
                    }
                    return null; // Valid
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                SizedBox(height: 10),
                Text('NIK', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: signupController.ktpNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    hintText: 'Your NIK',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NIK';
                    } else if (value.length != 16) {
                      return 'KTP number must be exactly 16 digits';
                    }
                    return null; // Valid
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Allow only numbers
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload your profile picture',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
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
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (value != null) {
                                          signupController.showImagePreview(
                                              context, value);
                                        }
                                      },
                                      child: Container(
                                        width: Get.width,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: value != null
                                              ? DecorationImage(
                                                  image: FileImage(value),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: value == null
                                            ? Icon(Icons.person,
                                                size: 100,
                                                color: Colors.grey[500])
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        signupController.showImageSourceDialog(
                                          context,
                                          'selfie',
                                          signupController,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('E97717'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.camera_alt,
                                              color: Colors.white),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              value == null
                                                  ? "Attach"
                                                  : "Retake",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (value == null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          'Profile picture is required to proceed.',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload your KTP picture',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ValueListenableBuilder<File?>(
                              valueListenable: signupController.ktpImage,
                              builder: (context, value, child) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (value != null) {
                                          signupController.showImagePreview(
                                              context, value);
                                        }
                                      },
                                      child: Container(
                                        width: Get.width,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: value != null
                                              ? DecorationImage(
                                                  image: FileImage(value),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: value == null
                                            ? Icon(Icons.person,
                                                size: 100,
                                                color: Colors.grey[500])
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        signupController.showImageSourceDialog(
                                          context,
                                          'ktp',
                                          signupController,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('E97717'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.camera_alt,
                                              color: Colors.white),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              value == null
                                                  ? "Attach"
                                                  : "Retake",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (value == null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          'KTP picture is required to proceed.',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        // signupController.nameController.text =
                        //     nameController.text;
                        // signupController.areaController.text =
                        //     areaController.text;
                        // signupController.divisionController.text =
                        //     divisionController.text;
                        // signupController.departmentController.text =
                        //     departmentController.text;
                        // signupController.addressController.text =
                        //     addressController.text;
                        // signupController.whatsappNumberController.text =
                        //     whatsappNumberController.text;
                        // signupController.ktpNumberController.text =
                        //     ktpNumberController.text;
                        signupController.nextPage();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 16),
                      backgroundColor: HexColor('E97717'),
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
                SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
