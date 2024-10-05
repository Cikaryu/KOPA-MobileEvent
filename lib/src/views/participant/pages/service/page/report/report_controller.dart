import 'dart:async';
import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs; // Menyimpan status laporan
  var statusImageUrls =
      <String, String>{}.obs; // Menyimpan URL gambar berdasarkan status
  final RxBool isLoading = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  late Rx<User?> _user;
  static const int maxImageCount = 5;
  final currentImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.currentUser);
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
    });
  }

  String get userId => _user.value?.uid ?? '';

  Future<String> getUserName() async {
    if (_user.value != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user.value!.uid).get();
      return userDoc['name'] ?? '';
    }
    return '';
  }

  Future<void> pickImages() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Image Source",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Choose an image from",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child:
                        Text("Camera", style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child:
                        Text("Gallery", style: TextStyle(color: Colors.white)),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (source != null) {
      List<XFile>? images = [];
      if (source == ImageSource.camera) {
        final XFile? image =
            await _picker.pickImage(source: source, imageQuality: 20);
        if (image != null) images.add(image);
      } else {
        images = await _picker.pickMultiImage(imageQuality: 20);
      }

      if (images.isNotEmpty) {
        int remainingSlots = 5 - selectedImages.length;
        if (images.length > remainingSlots) {
          Get.snackbar('Limit Reached', 'You can only upload up to 5 images.');
          images = images.sublist(0, remainingSlots);
        }
        selectedImages.addAll(images);
      }
    }
  }

  void showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  maxHeight: MediaQuery.of(context).size.height *
                      0.8, // 80% of screen height
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Optimize image upload function
  Future<List<String>> uploadImages(String reportId, List<XFile> images) async {
    List<Future<String>> uploadFutures = [];
    for (int i = 0; i < images.length; i++) {
      uploadFutures.add(_uploadSingleImage(reportId, images[i], i));
    }
    return await Future.wait(uploadFutures);
  }

  Future<String> _uploadSingleImage(
      String reportId, XFile image, int index) async {
    try {
      String fileName = 'report_${index + 1}.jpg';
      String filePath = 'report/$reportId/$fileName';
      await _storage.ref(filePath).putFile(File(image.path));
      return await _storage.ref(filePath).getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return "";
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
      sheets.SheetsApi.spreadsheetsScope,
    ];

    final authClient =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

  // Optimize Google Drive upload
  Future<void> uploadImageToDrive(
      File imageFile, String folderId, String title) async {
    final authClient = await getAuthClient();
    var driveApi = drive.DriveApi(authClient);

    String timestamp = DateFormat('ddMMyy').format(DateTime.now());
    String fileName = '${timestamp}_$title.png';
    var fileToUpload = drive.File()
      ..name = fileName
      ..parents = [folderId];
    var media = drive.Media(imageFile.openRead(), await imageFile.length());

    try {
      final response =
          await driveApi.files.create(fileToUpload, uploadMedia: media);
      print('Uploaded File ID: ${response.id} with name: $fileName');
    } catch (e) {
      print('Error uploading to Google Drive: $e');
    }
  }

// Google Sheet
  Future<void> submitToGoogleSheets(
      String title, String description, String status) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    // Replace with your actual spreadsheet ID
    final spreadsheetId = '1HXCINYDRoWg4Xs0sag2g7K7DEbiLCxNypnjOWOTDG9U';
    final range = 'Sheet1!A:F'; // This will append to the first empty row

    try {
      // First, try to get the spreadsheet metadata
      final spreadsheet = await sheetsApi.spreadsheets.get(spreadsheetId);
      print(
          'Successfully accessed spreadsheet: ${spreadsheet.properties?.title}');

      String userName = await getUserName();
      String timestamp = DateFormat('dd/MM/yyyy HH:mm:ss')
          .format(DateTime.now().toUtc().add(Duration(hours: 8)));

      final values = [
        [timestamp, userName, title, description, '', status]
      ];

      final valueRange = sheets.ValueRange(values: values);

      final result = await sheetsApi.spreadsheets.values.append(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
        insertDataOption: 'INSERT_ROWS',
      );

      print(
          'Data appended to Google Sheets successfully. Updated range: ${result.updates?.updatedRange}');
    } catch (e) {
      print('Error interacting with Google Sheets: $e');
      if (e is sheets.DetailedApiRequestError) {
        print('Error status: ${e.status}, message: ${e.message}');
        print('Error details: ${e.jsonResponse}');
      }
      // Handle the error as needed
      // You might want to show an error message to the user here
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> submitReport({
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      setLoading(true);

      String folderId = '14tlzo2Nj7_Fk9t3L5lVqBkBG9yVawHra';

      if (_user.value == null) {
        throw Exception('User not logged in');
      }

      String userName = await getUserName();

      // Generate a unique reportId
      String reportId = _firestore.collection('report').doc().id;

      // Prepare futures for concurrent execution
      List<Future> futures = [
        uploadImages(reportId, selectedImages),
        submitToGoogleSheets(title, description, status),
      ];

      // Execute futures concurrently
      List results = await Future.wait(futures);

      List<String> imageUrls = results[0];

      // Create new report document
      await _firestore.collection('report').doc(reportId).set({
        'userId': userId,
        'name': userName,
        'title': title,
        'description': description,
        'image': imageUrls,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Upload image to Google Drive in parallel
      for (int i = 0; i < selectedImages.length; i++) {
        unawaited(uploadImageToDrive(
            File(selectedImages[i].path), folderId, '${title}_${i + 1}'));
      }

      setLoading(false);
      // Show success dialog
      Get.dialog(
        AlertDialog(
          title: Text('Success',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text('Report submitted successfully!',
              textAlign: TextAlign.center),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
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
                    Get.back(); // Close dialog
                    Get.back();
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      );

      // Reset form
      resetForm();
    } catch (e) {
      setLoading(false);
      Get.dialog(
        AlertDialog(
          title: Text('Failed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text('Failed to submit report: $e'),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
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
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void resetForm() {
    selectedImage.value = null;
    selectedImages.clear();
  }

  void onGoBack() {
    resetForm();
    Get.back();
  }

  // Future<void> fetchStatusImage(String reportId, String status) async {
  //   String imageName;

  //   switch (status) {
  //     case 'Unresolved':
  //       imageName = 'close.png';
  //       break;
  //     case 'Resolved':
  //       imageName = 'received.png';
  //       break;
  //     case 'Pending':
  //       imageName = 'pending.png';
  //       break;
  //     default:
  //       imageName = 'default.png';
  //   }

  //   debugPrint('Image name determined: $imageName'); // Debug statement

  //   try {
  //     final downloadUrl = await FirebaseStorage.instance
  //         .ref('status/$imageName')
  //         .getDownloadURL();
  //     debugPrint('Fetched image URL: $downloadUrl'); // Debug statement
  //     statusImageUrls[reportId] = downloadUrl; // Menyimpan URL gambar
  //   } catch (e) {
  //     debugPrint('Error fetching status image: $e'); // Debug statement
  //     statusImageUrls[reportId] = ''; // Set to empty string if failed
  //   }
  // }
  String getStatusImagePath(String status) {
    switch (status) {
      case 'Not Started':
        return 'assets/icons/status/ic_not_started.svg';
      case 'In Progress':
        return 'assets/icons/status/ic_in_progress.svg';
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Resolved':
        return 'assets/icons/status/ic_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg'; // Fallback image
    }
  }

  Future<List<QueryDocumentSnapshot>> getReports() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('report')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs;
    }
    return [];
  }
}
