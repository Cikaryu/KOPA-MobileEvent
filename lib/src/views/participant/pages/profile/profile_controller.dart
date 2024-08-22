import 'dart:async';
import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var userArea = ''.obs;
  var userDepartment = ''.obs;
  var userAlamat = ''.obs;
  var userWhatsapp = ''.obs;
  var numberKtp = ''.obs; // Tambahkan field status
  var isMerchExpanded = false.obs;
  var isSouvenirExpanded = false.obs;
  var isBenefitExpanded = false.obs;
  var isLoadingStatusImage = true.obs;
  var statusImageUrl = ''.obs; // Tambahkan field untuk URL gambar status
  var selfieImage = Rxn<File>();
  var imageUrl = ''.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = false.obs;

  // Call this to load data initially
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    getUserData;
  }

  void toggleMerchExpanded() {
    isMerchExpanded.value = !isMerchExpanded.value;
    if (isMerchExpanded.value) {
      isSouvenirExpanded.value = false;
      isBenefitExpanded.value = false;
    }
  }

  void toggleSouvenirExpanded() {
    isSouvenirExpanded.value = !isSouvenirExpanded.value;
    if (isSouvenirExpanded.value) {
      isMerchExpanded.value = false;
      isBenefitExpanded.value = false;
    }
  }

  void toggleBenefitExpanded() {
    isBenefitExpanded.value = !isBenefitExpanded.value;
    if (isBenefitExpanded.value) {
      isMerchExpanded.value = false;
      isSouvenirExpanded.value = false;
    }
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
    participantKitSubscription?.cancel();
    participantKitSubscription = null;
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

        // Add merchandise status and fetch images
        merchandise.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Add souvenirs status and fetch images
        souvenirs.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Add benefits status and fetch images
        benefits.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Call update() on the controller to refresh the UI if needed
      } else {
        debugPrint('No participantKit data found');
      }
    });
  }

  Future<void> fetchStatusImage(String key, String status) async {
    String imageName;

    switch (status) {
      case 'Pending':
        imageName = 'pending.png';
        break;
      case 'Received':
        imageName = 'received.png';
        break;
      case 'Close':
        imageName = 'close.png';
        break;
      default:
        imageName = 'default.png';
    }

    try {
      final downloadUrl = await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
      statusImageUrls[key] = downloadUrl;
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrls[key] = ''; // Set to empty string if failed
    }
  }

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

  Future<void> saveChanges() async {
    try {
      setLoading(true);
      await Future.delayed(Duration(milliseconds: 500));

      User? user = FirebaseAuth.instance.currentUser;

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

      // Reset form setelah berhasil menyimpan
      fetchUserData();
      resetForm();
    } catch (e) {
      debugPrint('Error saving changes: $e');
      // Anda bisa menampilkan dialog kesalahan kepada pengguna jika perlu
    } finally {
      setLoading(false);
      Get.back();
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
}
