import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

  bool canPop = true;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var qrCodeUrl = ''.obs;
  var tShirtSize = ''.obs;
  var poloSize = ''.obs;
  var status = ''.obs;
  var userArea = ''.obs;
  var userDepartment = ''.obs;
  var userAlamat = ''.obs;
  var userWhatsapp = ''.obs;
  var numberKtp = ''.obs; // Tambahkan field status
  var isMerchExpanded = false.obs;
  var isSouvenirExpanded = false.obs;
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
        userDivisi.value = data['divisi'] ?? '';
        // Get the profile image URL from Firestore
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
      await getParticipantKitStatus(user); // Ambil status merchandise
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
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
        userDivisi.value = doc['divisi'];
        userArea.value = doc['area'];
        userDepartment.value = doc['department'];
        userAlamat.value = doc['alamat'];
        userWhatsapp.value = doc['nomorWhatsapp'];
        numberKtp.value = doc['nomorKtp'];
        tShirtSize.value = doc['ukuranTShirt'];
        poloSize.value = doc['ukuranPoloShirt'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> getParticipantKitStatus(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final kitStatus = doc['status'];
        status.value = kitStatus; // Set status

        // Ambil URL gambar status berdasarkan status merchandise
        await fetchStatusImage(kitStatus);
      } else {
        debugPrint('No participantKit data found');
      }
    } catch (e) {
      debugPrint('Error fetching participantKit data: $e');
    }
  }

  Future<void> fetchStatusImage(String status) async {
    isLoadingStatusImage.value = true; // Set loading menjadi true
    String imageName;

    switch (status) {
      case 'pending':
        imageName = 'pending.png';
        break;
      case 'received':
        imageName = 'received.png';
        break;
      case 'not received':
        imageName = 'not_received.png';
        break;
      default:
        imageName = 'default.png'; // Gambar default jika status tidak dikenali
    }

    try {
      statusImageUrl.value = await FirebaseStorage.instance
          .ref()
          .child('status/$imageName')
          .getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrl.value = ''; // Set ke kosong jika gagal
    } finally {
      isLoadingStatusImage.value = false; // Set loading menjadi false
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
            Text(userName.value),
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
      String divisi = divisiController.text.trim();
      String department = departmentController.text.trim();
      String alamat = alamatController.text.trim();
      String whatsappNumber = whatsappNumberController.text.trim();
      String noKTP = numberKTPController.text.trim();

      // Buat map untuk data yang akan diupdate
      Map<String, dynamic> updateData = {};

      // Tambahkan field hanya jika tidak kosong
      if (name.isNotEmpty) updateData['name'] = name;
      if (area.isNotEmpty) updateData['area'] = area;
      if (divisi.isNotEmpty) updateData['divisi'] = divisi;
      if (department.isNotEmpty) updateData['department'] = department;
      if (alamat.isNotEmpty) updateData['alamat'] = alamat;
      if (whatsappNumber.isNotEmpty) {
        updateData['nomorWhatsapp'] = whatsappNumber;
      }
      if (noKTP.isNotEmpty) updateData['noKTP'] = noKTP;

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

  Future<void> fetchData() async {
    try {
      // Mendapatkan pengguna yang sedang terautentikasi
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Ambil data dari Firestore berdasarkan user ID
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users') // Ganti dengan nama koleksi Anda
            .doc(currentUser.uid) // ID pengguna saat ini
            .get();

        // Update nilai di controller
        userName.value = snapshot['name'];
        userEmail.value = snapshot['email'];
        userDivisi.value = snapshot['divisi'];
        // Update nilai lainnya sesuai kebutuhan
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset link has been sent to $email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/signin');
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

  void pickImage(
      ImageSource source, ProfileController profileController) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

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
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 10),
                      Text('Camera'),
                    ],
                  ),
                  onTap: () {
                    pickImage(ImageSource.camera, profileController);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 10),
                      Text('Gallery'),
                    ],
                  ),
                  onTap: () {
                    pickImage(ImageSource.gallery, profileController);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
