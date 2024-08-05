import 'dart:io';

import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:app_kopabali/src/core/base_import.dart';

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
    final SignupController signupController = Get.put(SignupController());
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

    return GestureDetector(
      onTap: () {
        // Hide the keyboard and lose focus when tapped outside of a text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: Color(0xFFF5F5F5),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _areaController,
                      decoration: InputDecoration(
                        hintText: 'Area',
                        prefixIcon: Icon(Icons.location_on),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your area' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _divisiController,
                      decoration: InputDecoration(
                        hintText: 'Divisi',
                        prefixIcon: Icon(Icons.work),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your divisi' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _departmentController,
                      decoration: InputDecoration(
                        hintText: 'Department',
                        prefixIcon: Icon(Icons.business),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your department'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        hintText: 'Alamat',
                        prefixIcon: Icon(Icons.location_on),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9., ]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your alamat' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nomorWhatsappController,
                      decoration: InputDecoration(
                        hintText: 'Nomor Whatsapp',
                        prefixIcon: Icon(Icons.phone),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your nomor' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nomorKtpController,
                      decoration: InputDecoration(
                        hintText: 'Nomor KTP',
                        prefixIcon: Icon(Icons.credit_card),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your KTP' : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        hintText: 'Ukuran T-Shirt',
                        prefixIcon: Icon(Icons.format_size),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        width: 100,
                        offset: Offset(258, 55),
                        elevation: 5,
                        padding: EdgeInsets.all(10),
                      ),
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
                    SizedBox(height: 10),
                    DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        hintText: 'Ukuran Polo Shirt',
                        prefixIcon: Icon(Icons.format_size),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        width: 100,
                        offset: Offset(258, 55),
                        elevation: 5,
                        padding: EdgeInsets.all(10),
                      ),
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
                    SizedBox(height: 10),
                    DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        hintText: 'Tipe E-Wallet',
                        prefixIcon: Icon(Icons.wallet_outlined),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        maxHeight: 240,
                        width: 140,
                        offset: Offset(224, 55),
                        elevation: 5,
                        padding: EdgeInsets.all(10),
                      ),
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
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nomorEWalletController,
                      decoration: InputDecoration(
                        hintText: 'Nomor E-Wallet',
                        prefixIcon: Icon(Icons.credit_card),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your E-Wallet' : null,
                    ),
                    SizedBox(height: 10),
                    Text('Foto Diri',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder<File?>(
                          valueListenable: signupController.selfieImage,
                          builder: (context, value, child) {
                            return Container(
                              width: 210,
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
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            signupController.showImageSourceDialog(
                              context,
                              'selfie',
                              signupController,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Attach",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Foto KTP',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder<File?>(
                          valueListenable: signupController.ktpImage,
                          builder: (context, value, child) {
                            return Container(
                              width: 210,
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
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            signupController.showImageSourceDialog(
                              context,
                              'ktp',
                              signupController,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Attach",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
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
                              role: 'participant',
                              status: 'pending',
                              createdAt: Timestamp.now(),
                              updatedAt: Timestamp.now(),
                            );
                            // Call resetForm() after successful registration
                            signupController.resetForm();
                          } catch (error) {
                            // Error handling
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(horizontal: 154, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Sign up",
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SigninView()),
                              );
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  color: Colors.blue[300], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (signupController.isLoading)
              Opacity(
                opacity: 0.5, // Sesuaikan nilai opacity di sini
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            if (signupController.isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
