import 'dart:typed_data';

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class EditProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              profileController.resetForm;
              Get.back();
            },
          ),
          title: Text('Edit Profile'),
        ),
        body: Obx(() {
          return Stack(
            children: [
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Obx(() {
                            return GestureDetector(
                              onTap: () {
                                if (profileController.imageBytes.value !=
                                    null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImagePreviewPage(
                                        imageBytes:
                                            profileController.imageBytes.value!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 82,
                                    height: 82,
                                    decoration: ShapeDecoration(
                                      image:
                                          profileController.imageBytes.value !=
                                                  null
                                              ? DecorationImage(
                                                  image: MemoryImage(
                                                      profileController
                                                          .imageBytes.value!),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                      shape: OvalBorder(),
                                    ),
                                    child: profileController.imageBytes.value ==
                                            null
                                        ? Icon(Icons.person,
                                            size: 82, color: Colors.grey[500])
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        profileController.showImageSourceDialog(
                                            context, profileController);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 28),
                        Text('Name'),
                        TextFormField(
                          controller: profileController.nameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          decoration: InputDecoration(
                            hintText: profileController.userName.value,
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          decoration: InputDecoration(
                            hintText: profileController.userArea.value,
                            prefixIcon: Icon(Icons.location_on),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Text('Division'),
                        TextFormField(
                          controller: profileController.divisiController,
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          decoration: InputDecoration(
                            hintText: profileController.userDivisi.value,
                            prefixIcon: Icon(Icons.work),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          decoration: InputDecoration(
                            hintText: profileController.userDepartment.value,
                            prefixIcon: Icon(Icons.business),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9., ]'))
                          ],
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          decoration: InputDecoration(
                            hintText: profileController.userAlamat.value,
                            prefixIcon: Icon(Icons.location_on),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Text('WhatsApp Number'),
                        TextFormField(
                          controller:
                              profileController.whatsappNumberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          maxLength: 13,
                          decoration: InputDecoration(
                            hintText: profileController.userWhatsapp.value,
                            prefixIcon: Icon(Icons.phone),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Text('NIK'),
                        TextFormField(
                          controller: profileController.numberKTPController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          validator: (value) =>
                              value!.isEmpty ? 'Data tidak boleh kosong' : null,
                          maxLength: 16,
                          decoration: InputDecoration(
                            hintText: profileController.numberKtp.value,
                            prefixIcon: Icon(Icons.credit_card),
                            filled: true,
                            fillColor: HexColor('F3F3F3'),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Indikator loading transparan
              if (profileController.isLoading.value)
                Container(
                  color: Colors.black54, // Warna latar belakang transparan
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final Uint8List imageBytes;

  const ImagePreviewPage({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto Profil'),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: MemoryImage(imageBytes),
        ),
      ),
    );
  }
}
