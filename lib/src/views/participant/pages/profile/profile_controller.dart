import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/event_organizer/event_organizer_view.dart';
import 'package:app_kopabali/src/views/participant/pages/home/home_page_controller.dart';
import 'package:app_kopabali/src/views/participant/participant_view.dart';
import 'package:app_kopabali/src/views/super_eo/super_eo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController divisiController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController numberKTPController = TextEditingController();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      participantKitSubscription;

  bool canPop = true;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var qrCodeUrl = ''.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;
  var role = ''.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var userArea = ''.obs;
  var userDepartment = ''.obs;
  var userAlamat = ''.obs;
  var userWhatsapp = ''.obs;
  var numberKtp = ''.obs; // Tambahkan field status
  var expandedContainer = RxString('');
  var isLoadingStatusImage = true.obs;
  var statusImageUrl = ''.obs; // Tambahkan field untuk URL gambar status
  var selfieImage = Rxn<File>();
  var imageUrl = ''.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = false.obs;
  var hasPreviouslyBeenCommittee = false.obs;
  var hasPreviouslyBeenSuperEO = false.obs;
  var hasPreviouslyBeenEventOrganizer = false.obs;

  // Call this to load data initially
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    getUserData;
    getUserRole();
  }

  void toggleContainerExpansion(String containerName) {
    expandedContainer.value =
        expandedContainer.value == containerName ? '' : containerName;
  }

  bool isContainerExpanded(String containerName) {
    return expandedContainer.value == containerName;
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userDivisi.value = data['division'] ?? '';
        userArea.value = data['area'] ?? '';
        userDepartment.value = data['department'] ?? '';
        userAlamat.value = data['address'] ?? '';
        userWhatsapp.value = data['whatsappNumber'] ?? '';
        numberKtp.value = data['NIK'] ?? '';
        hasPreviouslyBeenCommittee.value = data['wasCommittee'] ?? false;
        hasPreviouslyBeenEventOrganizer.value =
            data['wasEventOrganizer'] ?? false;
        hasPreviouslyBeenSuperEO.value = data['wasSuperEO'] ?? false;
        String imageUrl = data['profileImageUrl'] ?? '';
        if (imageUrl.isNotEmpty) {
          var response = await FirebaseStorage.instance.ref(imageUrl).getData();
          if (response != null) {
            imageBytes.value = response;
          }
        }
      }
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setSelfieImage(File image) {
    selfieImage.value = image;
    image.readAsBytes().then((bytes) {
      imageBytes.value = bytes;
    });
  }

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getUserData(user);
      await getImageBytes(user);
      await fetchQrCodeUrl(); // Ambil QR code saat controller siap
      listenToParticipantKitStatus(user); // Ambil status merchandise
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  void refreshData() async {
    setLoading(true);
    await Future.delayed(Duration(milliseconds: 500));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await getUserData(user); // Refresh user data
        await getImageBytes(user); // Refresh profile image
        await fetchQrCodeUrl(); // Refresh QR code
        listenToParticipantKitStatus(user); // Refresh participant kit status
      } else {
        debugPrint("User not logged in");
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    final HomePageParticipantController homePageController =
        Get.find<HomePageParticipantController>();
    await participantKitSubscription?.cancel();
    participantKitSubscription = null;
    // Hentikan listener Firestore
    await homePageController.userSubscription?.cancel();
    homePageController.userSubscription = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    return Get.offAllNamed('/signin');
  }

  Future<void> getImageBytes(User user) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('/users/participant/${user.uid}/selfie/selfie.jpg');
      debugPrint('Fetching image from path: ${ref.fullPath}');
      final data = await ref.getData();
      if (data != null) {
        debugPrint('Image data length: ${data.length}');
        imageBytes.value = data;
      } else {
        debugPrint('No image data found');
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
    }
  }

  Future<void> getUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        userName.value = doc['name'];
        userEmail.value = doc['email'];
        userDivisi.value = doc['division'];
        userArea.value = doc['area'];
        userDepartment.value = doc['department'];
        userAlamat.value = doc['address'];
        userWhatsapp.value = doc['whatsappNumber'];
        numberKtp.value = doc['NIK'];
        tShirtSize.value = doc['tShirtSize'];
        poloShirtSize.value = doc['poloShirtSize'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  void listenToParticipantKitStatus(User user) {
    participantKitSubscription = FirebaseFirestore.instance
        .collection('participantKit')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final participantKit = doc.data()!;
        final merchandise = participantKit['merchandise'] ?? {};
        final souvenirs = participantKit['souvenir'] ?? {};
        final benefits = participantKit['benefit'] ?? {};

        // Clear previous status
        status.clear();
        statusImageUrls.clear();

        // Add merchandise status and map to local image paths
        merchandise.forEach((key, value) {
          String compositeKey = 'merchandise.$key';
          status[compositeKey] = value['status'];
          statusImageUrls[compositeKey] = getStatusImagePath(value['status']);
        });

        // Add souvenirs status and map to local image paths
        souvenirs.forEach((key, value) {
          String compositeKey = 'souvenir.$key';
          status[compositeKey] = value['status'];
          statusImageUrls[compositeKey] = getStatusImagePath(value['status']);
        });

        // Add benefits status and map to local image paths
        benefits.forEach((key, value) {
          String compositeKey = 'benefit.$key';
          status[compositeKey] = value['status'];
          statusImageUrls[compositeKey] = getStatusImagePath(value['status']);
        });

        // Update the UI
        update();
      } else {
        debugPrint('No participantKit data found');
      }
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Received':
        return Colors.green;
      case 'Pending':
        return HexColor('F0B811');
      case 'Not Received':
        return Colors.red;
      default:
        print('Unhandled status: $status'); // Debugging statement
        return Colors.grey; // Default color for unknown status
    }
  }

  String getStatusForItem(String category, String item) {
    return status['$category.$item'] ?? 'Pending';
  }

  String getStatusImagePath(String status) {
    switch (status) {
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Received':
        return 'assets/icons/status/ic_received.svg';
      case 'Not Received':
        return 'assets/icons/status/ic_not_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg'; // Fallback image
    }
  }

  // Future<void> fetchStatusImage(String key, String status) async {
  //   String imageName;

  //   switch (status) {
  //     case 'Pending':
  //       imageName = 'pending.png';
  //       break;
  //     case 'Received':
  //       imageName = 'received.png';
  //       break;
  //     case 'Not Received':
  //       imageName = 'close.png';
  //       break;
  //     default:
  //       imageName = 'default.png';
  //   }

  //   try {
  //     final downloadUrl = await FirebaseStorage.instance
  //         .ref('status/$imageName')
  //         .getDownloadURL();
  //     statusImageUrls[key] = downloadUrl;
  //   } catch (e) {
  //     debugPrint('Error fetching status image: $e');
  //     statusImageUrls[key] = ''; // Set to empty string if failed
  //   }
  // }

  Future<void> fetchQrCodeUrl() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          '/users/participant/${FirebaseAuth.instance.currentUser!.uid}/qr/qr.jpg');
      qrCodeUrl.value = await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching QR code: $e');
    }
  }

  void showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('QR Code'),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            qrCodeUrl.isNotEmpty
                ? Image.network(
                    qrCodeUrl.value,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(
              userName.value,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text('Show this QR Code to the commitee')
          ]),
          actions: [
            Center(
              child: Container(
                width: 164,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadImageToStorage(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users/participant/${user.uid}/selfie/selfie.jpg');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> updateProfileImageUrl(String imageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'selfieUrl': imageUrl});
    } catch (e) {
      throw Exception('Error updating profile image URL: $e');
    }
  }

  Future<String> loadCredentials() async {
    return await rootBundle.loadString('assets/credentials/credentials.json');
  }

  Future<AuthClient> getAuthClient() async {
    String credentials = await loadCredentials();
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final scopes = [
      drive.DriveApi.driveFileScope,
      sheets.SheetsApi.spreadsheetsScope
    ];

    final authClient =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

  Future<void> uploadOrUpdateFileInDrive(File imageFile) async {
    final authClient = await getAuthClient();
    var driveApi = drive.DriveApi(authClient);

    // Fetch user details
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    String name = nameController.text.trim();
    String area = areaController.text.trim();
    String department = departmentController.text.trim();
    String division = divisiController.text.trim();

    // Build the new file name based on user details
    String newFileName = '${area}_${department}_${division}_$name.png';

    // Folder ID for '1. FOTO DIRI' under the base folder
    String photoFolderId = "1ct2JFxdNvEjWUb0slhBROiPGvy5v5Ode";

    // Fetch the old file name from Firestore (if stored)
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    String oldFileName = userDoc['profileFileName'] ?? '';

    // If the file name has changed (due to changes in area, department, division, or name)
    if (oldFileName.isNotEmpty && oldFileName != newFileName) {
      // Search for the old file in Google Drive
      String query =
          "'$photoFolderId' in parents and name = '$oldFileName' and trashed = false";
      var fileList = await driveApi.files.list(q: query, spaces: 'drive');

      // If the old file exists, delete it
      if (fileList.files!.isNotEmpty) {
        String oldFileId = fileList.files!.first.id!;
        await driveApi.files.delete(oldFileId);
        print('Deleted old file with name: $oldFileName');
      }
    }

    // Check if the file already exists with the new name
    String query =
        "'$photoFolderId' in parents and name = '$newFileName' and trashed = false";
    var fileList = await driveApi.files.list(q: query, spaces: 'drive');

    if (fileList.files!.isNotEmpty) {
      // File exists, update it
      var existingFileId = fileList.files!.first.id!;
      var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

      var updatedFile = await driveApi.files.update(
        drive.File(), // Add more file metadata if needed here
        existingFileId,
        uploadMedia: media,
      );
      print('Updated File ID: ${updatedFile.id} with name: $newFileName');
    } else {
      // File doesn't exist, create a new one
      var fileToUpload = drive.File();
      fileToUpload.name = newFileName;
      fileToUpload.parents = [photoFolderId];

      var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());
      final response =
          await driveApi.files.create(fileToUpload, uploadMedia: media);

      print('Uploaded new File ID: ${response.id} with name: $newFileName');
    }

    // Update the new file name in Firestore to track for future updates
    await updateOldFileNameInFirestore(newFileName);
  }

  Future<void> updateOldFileNameInFirestore(String newFileName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Store the new file name in Firestore for tracking
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'profileFileName': newFileName,
    });
  }

  Future<void> updateGoogleSheets(String userId) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    const spreadsheetId = '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY';
    const range = 'Sheet1!A:J'; // Include the range from column A to J

    try {
      // Get user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!userDoc.exists) {
        print('User not found');
        return;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Fetch current values from Google Sheets
      final response =
          await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      final values = response.values;

      if (values == null || values.isEmpty) {
        print('No data found in Google Sheets');
        return;
      }

      int rowIndex = -1;
      for (int i = 1; i < values.length; i++) {
        if (values[i].length > 1 && values[i][1] == userId) {
          // UserId is in column B
          rowIndex = i + 1; // Google Sheets is 1-indexed
          break;
        }
      }

      if (rowIndex != -1) {
        // Ensure we don't attempt to sublist outside the actual range
        if (values[rowIndex - 1].length >= 10) {
          List<String> currentValues = values[rowIndex - 1]
              .sublist(3, 10)
              .map((e) => e?.toString() ?? '')
              .toList();
          List<String> updatedValues = [
            userData['name'],
            userData['area'],
            userData['division'],
            userData['department'],
            userData['address'],
            userData['whatsappNumber'],
            userData['NIK']
          ];

          if (!listEquals(currentValues, updatedValues)) {
            final updateRange = 'Sheet1!D$rowIndex:J$rowIndex';
            final valueRange = sheets.ValueRange(values: [updatedValues]);

            await sheetsApi.spreadsheets.values.update(
              valueRange,
              spreadsheetId,
              updateRange,
              valueInputOption: 'USER_ENTERED',
            );
            print('Updated Google Sheets.');
          } else {
            print('No changes detected.');
          }
        } else {
          print("Error: Row doesn't contain enough columns to update.");
        }
      } else {
        // Append new row if user not found
        final appendRange = 'Sheet1!D:J';
        final valueRange = sheets.ValueRange(values: [
          [
            userData['name'],
            userData['area'],
            userData['division'],
            userData['department'],
            userData['address'],
            userData['whatsappNumber'],
            userData['NIK']
          ]
        ]);
        await sheetsApi.spreadsheets.values.append(
          valueRange,
          spreadsheetId,
          appendRange,
          valueInputOption: 'USER_ENTERED',
          insertDataOption: 'INSERT_ROWS',
        );
        print('New row added to Google Sheets.');
      }
    } catch (e) {
      if (e is sheets.DetailedApiRequestError) {
        print('Status: ${e.status}, Message: ${e.message}');
      } else {
        print('General Error: $e');
      }
    }
  }

  Future<void> updateNameOnlyInGoogleSheets(
      String oldName, String newName) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    const spreadsheetId = '1YY4nOT_a--4sqqgtT7mpT3PH8CPQsLM5ZbVKAtJzRLY';
    const range = 'Sheet1!A:A'; // Only looking at column A for names

    try {
      // Fetch current values from Google Sheets
      final response =
          await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      final values = response.values;

      if (values == null || values.isEmpty) {
        print('No data found in Google Sheets');
        return;
      }

      int rowIndex = -1;
      for (int i = 0; i < values.length; i++) {
        if (values[i].isNotEmpty && values[i][0] == oldName) {
          rowIndex = i + 1; // Google Sheets is 1-indexed
          break;
        }
      }

      if (rowIndex != -1) {
        // Update existing row
        final updateRange = 'Sheet1!A$rowIndex';
        final valueRange = sheets.ValueRange(values: [
          [newName]
        ]);

        await sheetsApi.spreadsheets.values.update(
          valueRange,
          spreadsheetId,
          updateRange,
          valueInputOption: 'USER_ENTERED',
        );
        print('Updated name from $oldName to $newName in Google Sheets.');
      } else {
        print('Name $oldName not found in Google Sheets.');
      }
    } catch (e) {
      if (e is sheets.DetailedApiRequestError) {
        print(
            'Google Sheets API Error - Status: ${e.status}, Message: ${e.message}');
      } else {
        print('Error updating name in Google Sheets: $e');
      }
    }
  }

  Future<void> updateNameGooglesheetFeedback(
      String oldName, String newName , String spreadsheetId) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    const range = 'Sheet1!B:B'; // Only looking at column A for names

       try {
    // Fetch current values from Google Sheets
    final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    final values = response.values;

    if (values == null || values.isEmpty) {
      print('No data found in Google Sheets');
      return;
    }

    int rowIndex = -1;
    for (int i = 0; i < values.length; i++) {
      if (values[i].isNotEmpty && values[i][0] == oldName) {
        rowIndex = i + 1; // Google Sheets is 1-indexed
        break;
      }
    }

    if (rowIndex != -1) {
      // Update existing row
      final updateRange = 'Sheet1!B$rowIndex';
      final valueRange = sheets.ValueRange(values: [[newName]]);

      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        updateRange,
        valueInputOption: 'USER_ENTERED',
      );
      print('Updated name from $oldName to $newName in Google Sheets.');
    } else {
      print('Name $oldName not found in Google Sheets.');
    }
  } catch (e) {
    if (e is sheets.DetailedApiRequestError) {
      print('Google Sheets API Error - Status: ${e.status}, Message: ${e.message}');
    } else {
      print('Error updating name in Google Sheets: $e');
    }
  }
}

  Future<void> updateNameGooglesheetReport(
      String oldName, String newName , String spreadsheetId) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    const range = 'Sheet1!B:B'; // Only looking at column A for names

      try {
    // Fetch current values from Google Sheets
    final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    final values = response.values;

    if (values == null || values.isEmpty) {
      print('No data found in Google Sheets');
      return;
    }

    List<int> rowIndices = [];
    for (int i = 0; i < values.length; i++) {
      if (values[i].isNotEmpty && values[i][0] == oldName) {
        rowIndices.add(i + 1); // Google Sheets is 1-indexed
      }
    }

    if (rowIndices.isNotEmpty) {
      // Update all matching rows
      for (int rowIndex in rowIndices) {
        final updateRange = 'Sheet1!B$rowIndex';
        final valueRange = sheets.ValueRange(values: [[newName]]);
        await sheetsApi.spreadsheets.values.update(
          valueRange,
          spreadsheetId,
          updateRange,
          valueInputOption: 'USER_ENTERED',
        );
      }
      print('Updated ${rowIndices.length} occurrences of $oldName to $newName in Google Sheets.');
    } else {
      print('Name $oldName not found in Google Sheets.');
    }
  } catch (e) {
    if (e is sheets.DetailedApiRequestError) {
      print('Google Sheets API Error - Status: ${e.status}, Message: ${e.message}');
    } else {
      print('Error updating names in Google Sheets: $e');
    }
  }
}

  Future<void> saveChanges() async {
    try {
      setLoading(true);
      await Future.delayed(Duration(milliseconds: 500));

      User? user = FirebaseAuth.instance.currentUser;

      String newName = nameController.text.trim();
      String oldName = userName.value;
      String SpreadsheetIdReport = '1HXCINYDRoWg4Xs0sag2g7K7DEbiLCxNypnjOWOTDG9U';
      String SpreadsheetIdFeedback = '1M3gfssXScdFuTzPbGg9wE3Bg9aldOPQKcMglMdRJtwc';

      if (user == null) return; // Pastikan pengguna terautentikasi

      // Mengambil data baru dari kontroler
      String name = nameController.text.trim();
      String area = areaController.text.trim();
      String division = divisiController.text.trim();
      String department = departmentController.text.trim();
      String address = alamatController.text.trim();
      String whatsappNumber = whatsappNumberController.text.trim();
      String noKTP = numberKTPController.text.trim();

      // Buat map untuk data yang akan diupdate
      Map<String, dynamic> updateData = {};

      // Tambahkan field hanya jika tidak kosong
      if (name.isNotEmpty) updateData['name'] = name;
      if (area.isNotEmpty) updateData['area'] = area;
      if (division.isNotEmpty) updateData['division'] = division;
      if (department.isNotEmpty) updateData['department'] = department;
      if (address.isNotEmpty) updateData['address'] = address;
      if (whatsappNumber.isNotEmpty) {
        updateData['whatsappNumber'] = whatsappNumber;
      }
      if (noKTP.isNotEmpty) updateData['NIK'] = noKTP;

      // Update gambar jika ada
      if (imageBytes.value != null) {
        // Gantilah path sesuai kebutuhan
        String imagePath = '/users/participant/${user.uid}/selfie/selfie.jpg';
        UploadTask uploadTask =
            FirebaseStorage.instance.ref(imagePath).putData(imageBytes.value!);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Tambahkan URL gambar ke data yang akan diupdate
        updateData['imageUrl'] =
            imageUrl; // Pastikan field ini ada di Firestore
      }

      // If a new image is selected, upload it to Google Drive and update the URL
      if (selfieImage.value != null) {
        // Use the uploadOrUpdateFileInDrive function to handle the file upload and update
        await uploadOrUpdateFileInDrive(selfieImage.value!);
      }

      // Pastikan setidaknya ada satu field yang akan diupdate
      if (updateData.isNotEmpty) {
        // Update data pengguna di Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updateData);
      } else {
        debugPrint('Tidak ada data yang diperbarui');
      }

      // Setelah data di Firestore berhasil diupdate, panggil updateGoogleSheets untuk mengupdate Google Sheets
      await updateGoogleSheets(user.uid);
      
      if (newName.isNotEmpty && newName != oldName) {
        // Update name in Google Sheets
        await updateNameOnlyInGoogleSheets(oldName, newName);
        await updateNameGooglesheetReport(oldName, newName, SpreadsheetIdReport);
        await updateNameGooglesheetFeedback(oldName, newName, SpreadsheetIdFeedback);
      }

      // Reset form setelah berhasil menyimpan
      fetchUserData();
      resetForm();
    } catch (e) {
      debugPrint('Error saving changes: $e');
      // Anda bisa menampilkan dialog kesalahan kepada pengguna jika perlu
    } finally {
      setLoading(false);
      Get.back();
      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
  }

  void resetForm() {
    nameController.text = userName.value;
    areaController.text = userArea.value;
    divisiController.text = userDivisi.value;
    departmentController.text = userDepartment.value;
    alamatController.text = userAlamat.value;
    whatsappNumberController.text = userWhatsapp.value;
    numberKTPController.text = numberKtp.value;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: HexColor("E97717"),
                border: Border(
                  top: BorderSide(color: Colors.orange[400]!),
                ),
              ),
              child: TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void pickImage(
      ImageSource source, ProfileController profileController) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      profileController.setSelfieImage(File(pickedFile.path));
    }
  }

  void showImageSourceDialog(
      BuildContext context, ProfileController profileController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose Image Source',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor("E97717"),
                          border: Border(
                            top: BorderSide(color: Colors.orange[400]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        pickImage(ImageSource.camera, profileController);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor("E97717"),
                          border: Border(
                            top: BorderSide(color: Colors.orange[400]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        pickImage(ImageSource.gallery, profileController);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Text(
              'A password reset link has been sent to $email.',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Center(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: HexColor("E97717"),
                        border: Border(
                          top: BorderSide(color: Colors.orange[400]!),
                        ),
                      ),
                      child: Text('OK', style: TextStyle(color: Colors.white))),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<void> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          role.value = userDoc['role'] ?? 'Participant';
        } else {
          print('Document does not exist on the database');
        }
      } catch (e) {
        print('Error getting role: $e');
      }
    } else {
      print('No user is signed in');
    }
  }

  Future<void> switchRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        if (role.value == 'Committee') {
          // Switch to Participant role
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'role': 'Participant',
            'wasCommittee': true,
          });
          role.value = 'Participant';

          // Tampilkan snackbar
          Get.snackbar(
            "Role Changed",
            "You have switched to the Participant role.",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAll(() => ParticipantView());
        } else if (role.value == 'Participant') {
          // Switch back to Committee, Super Event Organizer, or Event Organizer role
          if (hasPreviouslyBeenSuperEO.value) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'role': 'Super Event Organizer',
              'wasSuperEO': true,
            });
            role.value = 'Super Event Organizer';

            // Tampilkan snackbar
            Get.snackbar(
              "Role Changed",
              "You have switched to the Super Event Organizer role.",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            Get.offAll(() => SuperEOView());
          } else if (hasPreviouslyBeenEventOrganizer.value) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'role': 'Event Organizer',
              'wasEventOrganizer': true,
            });
            role.value = 'Event Organizer';

            // Tampilkan snackbar
            Get.snackbar(
              "Role Changed",
              "You have switched to the Event Organizer role.",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            Get.offAll(() => EventOrganizerView());
          } else if (hasPreviouslyBeenCommittee.value) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'role': 'Committee',
              'wasCommittee': true,
            });
            role.value = 'Committee';

            // Tampilkan snackbar
            Get.snackbar(
              "Role Changed",
              "You have switched to the Committee role.",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            Get.offAll(() => CommitteeView());
          }
        } else if (role.value == 'Super Event Organizer') {
          // Switch to Participant role
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'role': 'Participant',
            'wasSuperEO': true,
          });
          role.value = 'Participant';

          // Tampilkan snackbar
          Get.snackbar(
            "Role Changed",
            "You have switched to the Participant role.",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAll(() => ParticipantView());
        } else if (role.value == 'Event Organizer') {
          // Switch to Participant role
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'role': 'Participant',
            'wasEventOrganizer': true,
          });
          role.value = 'Participant';

          // Tampilkan snackbar
          Get.snackbar(
            "Role Changed",
            "You have switched to the Participant role.",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAll(() => ParticipantView());
        }
      } catch (e) {
        debugPrint('Error switching role: $e');
        // Tampilkan snackbar untuk error
        Get.snackbar(
          "Error",
          "Failed to switch role. Please try again.",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
