import 'dart:math';

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/participant_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileParticipantPage extends StatelessWidget {
  const ProfileParticipantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ParticipantController participantController =
        Get.put(ParticipantController());

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Profile')),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Kontainer untuk Profil
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: HexColor('F3F3F3'),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      // Informasi pengguna
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        width: 300,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: ShapeDecoration(
                                    image: participantController
                                                .imageBytes.value !=
                                            null
                                        ? DecorationImage(
                                            image: MemoryImage(
                                                participantController
                                                    .imageBytes.value!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    shape: OvalBorder(),
                                  ),
                                  child:
                                      participantController.imageBytes.value ==
                                              null
                                          ? Icon(Icons.person,
                                              size: 82, color: Colors.grey[500])
                                          : null,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        participantController.userName.value,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        participantController.userEmail.value,
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        participantController.userDivisi.value,
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Tombol untuk menampilkan QR
                      Container(
                        width: 164,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            await participantController.fetchQrCodeUrl();
                            participantController.showQrDialog(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(HexColor('E97717')),
                          ),
                          child: Text(
                            'Show QR',
                            style: TextStyle(color: HexColor('F3F3F3')),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Kontainer untuk Merchandise
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: HexColor('F3F3F3'),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          participantController.isExpanded.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Merch',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    participantController.isExpanded.value
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              AnimatedContainer(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                width: 300,
                                duration: Duration(milliseconds: 300),
                                height: participantController.isExpanded.value
                                    ? 240
                                    : 0,
                                curve: Curves.easeInOut,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Name',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Status',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Polo Shirt (${participantController.tShirtSize.value})',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          FutureBuilder<String>(
                                            future: FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'status/${participantController.status.value}.png')
                                                .getDownloadURL(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Icon(Icons.error);
                                              }
                                              return Row(
                                                children: [
                                                  Image.network(snapshot.data!,
                                                      width: 24, height: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    participantController
                                                        .status.value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'T-Shirt (${participantController.tShirtSize.value})',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          FutureBuilder<String>(
                                            future: FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'status/${participantController.status.value}.png')
                                                .getDownloadURL(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Icon(Icons.error);
                                              }
                                              return Row(
                                                children: [
                                                  Image.network(snapshot.data!,
                                                      width: 24, height: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    participantController
                                                        .status.value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Nametag',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          FutureBuilder<String>(
                                            future: FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'status/${participantController.status.value}.png')
                                                .getDownloadURL(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Icon(Icons.error);
                                              }
                                              return Row(
                                                children: [
                                                  Image.network(snapshot.data!,
                                                      width: 24, height: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    participantController
                                                        .status.value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Luggage Tag',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          FutureBuilder<String>(
                                            future: FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'status/${participantController.status.value}.png')
                                                .getDownloadURL(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Icon(Icons.error);
                                              }
                                              return Row(
                                                children: [
                                                  Image.network(snapshot.data!,
                                                      width: 24, height: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    participantController
                                                        .status.value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Jas Hujan',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          FutureBuilder<String>(
                                            future: FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'status/${participantController.status.value}.png')
                                                .getDownloadURL(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Icon(Icons.error);
                                              }
                                              return Row(
                                                children: [
                                                  Image.network(snapshot.data!,
                                                      width: 24, height: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    participantController
                                                        .status.value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
