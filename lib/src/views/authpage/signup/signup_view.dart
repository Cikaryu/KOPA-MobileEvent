// ignore_for_file: sort_child_properties_last

import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      body: signupController.isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 210,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.person,
                              size: 100, color: Colors.grey[500]),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            signupController.showImageSourceDialog(
                                context, 'selfie', signupController);
                          },
                          child: Text("Pick Selfie\nor Capture",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (signupController.selfieImage != null)
                          Image.file(signupController.selfieImage!),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.person,
                              size: 100, color: Colors.grey[500]),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            signupController.showImageSourceDialog(
                                context, 'ktp', signupController);
                          },
                          child: Text("Capture KTP",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (signupController.ktpImage != null)
                          Image.file(signupController.ktpImage!),
                      ],
                    ),
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
                      child: Text("Sign up",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(horizontal: 154, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                            onTap: () {},
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
    );
  }
}
