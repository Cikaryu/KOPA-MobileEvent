import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'dart:io';

class SignupView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _divisiController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorWhatsappController =
      TextEditingController();
  final TextEditingController _nomorKtpController = TextEditingController();
  final TextEditingController _ukuranTShirtController = TextEditingController();
  final TextEditingController _ukuranPoloShirtController =
      TextEditingController();
  final TextEditingController _tipeEWalletController = TextEditingController();
  final TextEditingController _nomorEWalletController = TextEditingController();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController =
      Get.put(SignupController());
    final List<String> ukuranOptions = ['S', 'M', 'L', 'XL', 'XXL'];
    final List<String> eWalletOptions = [
      'Dana',
      'OVO',
      'GoPay',
      'LinkAja',
      'Jenius',
      'ShopeePay',
      'PayPal'
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: signupController.isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        String pattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!regex.hasMatch(value) ||
                            !value.endsWith('.com')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    TextFormField(
                      controller: _areaController,
                      decoration: InputDecoration(labelText: 'Area'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your area' : null,
                    ),
                    TextFormField(
                      controller: _divisiController,
                      decoration: InputDecoration(labelText: 'Divisi'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your divisi' : null,
                    ),
                    TextFormField(
                      controller: _departmentController,
                      decoration: InputDecoration(labelText: 'Department'),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your department'
                          : null,
                    ),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(labelText: 'Alamat'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9., ]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your alamat' : null,
                    ),
                    TextFormField(
                      controller: _nomorWhatsappController,
                      decoration: InputDecoration(labelText: 'Nomor Whatsapp'),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your nomor' : null,
                    ),
                    TextFormField(
                      controller: _nomorKtpController,
                      decoration: InputDecoration(labelText: 'Nomor KTP'),
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your KTP' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Ukuran T-Shirt'),
                      items: ukuranOptions.map((String ukuran) {
                        return DropdownMenuItem<String>(
                          value: ukuran,
                          child: Text(ukuran),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _ukuranTShirtController.text = newValue!;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a size' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration:
                          InputDecoration(labelText: 'Ukuran Polo Shirt'),
                      items: ukuranOptions.map((String ukuran) {
                        return DropdownMenuItem<String>(
                          value: ukuran,
                          child: Text(ukuran),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _ukuranPoloShirtController.text = newValue!;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a size' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Tipe E-Wallet'),
                      items: eWalletOptions.map((String tipe) {
                        return DropdownMenuItem<String>(
                          value: tipe,
                          child: Text(tipe),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _tipeEWalletController.text = newValue!;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a type' : null,
                    ),
                    TextFormField(
                      controller: _nomorEWalletController,
                      decoration: InputDecoration(labelText: 'Nomor E-Wallet'),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your E-Wallet' : null,
                    ),
                    SizedBox(height: 20),
                    Text('Submit Foto Diri'),
                    ElevatedButton(
                      onPressed: () => _showImageSourceDialog(
                          context, 'selfie', signupController),
                      child: Text('Pick Selfie or Capture'),
                    ),
                    if (signupController.selfieImage != null)
                      Image.file(signupController.selfieImage!),
                    SizedBox(height: 20),
                    Text('Submit Foto KTP'),
                    ElevatedButton(
                      onPressed: () => _showImageSourceDialog(
                          context, 'ktp', signupController),
                      child: Text('Pick KTP or Capture'),
                    ),
                    if (signupController.ktpImage != null)
                      Image.file(signupController.ktpImage!),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await signupController.registerUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              area: _areaController.text,
                              divisi: _divisiController.text,
                              department: _departmentController.text,
                              alamat: _alamatController.text,
                              nomorWhatsapp: _nomorWhatsappController.text,
                              nomorKtp: _nomorKtpController.text,
                              ukuranTShirt: _ukuranTShirtController.text,
                              ukuranPoloShirt: _ukuranPoloShirtController.text,
                              tipeEWallet: _tipeEWalletController.text,
                              nomorEWallet: _nomorEWalletController.text,
                              context: context,
                              participant: 'participant',
                            );
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(error.toString()),
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
                        }
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showImageSourceDialog(BuildContext context, String type,
      SignupController signupController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera, type, signupController);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    _pickImage(ImageSource.gallery, type, signupController);
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

  void _pickImage(ImageSource source, String type,
      SignupController signupController) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (type == 'selfie') {
        signupController.setSelfieImage(File(pickedFile.path));
      } else {
        signupController.setKtpImage(File(pickedFile.path));
      }
    }
  }
}
