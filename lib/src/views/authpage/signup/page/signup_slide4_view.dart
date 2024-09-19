import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';

class SignupSlide4View extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignupSlide4View({super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment the following line if you need to use the SignupController.
    final SignupController signupController = Get.put(SignupController());
    final TextEditingController eWalletTypeController = TextEditingController(
        text: signupController.eWalletTypeController.text);
    final TextEditingController eWalletNumberController = TextEditingController(
        text: signupController.eWalletNumberController.text);
    final List<String> eWalletOptions = [
      'OVO',
      'GoPay',
    ];
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
                  "Your E - wallet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 10),
                Text('E - Wallet Type',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: 'Choose E - Wallet Type',
                    hintStyle: TextStyle(
                        fontSize: 16, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
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
                    eWalletTypeController.text = newValue!;
                  },
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
                SizedBox(height: 10),
                Text('E - Wallet Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextFormField(
                  controller: eWalletNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  decoration: InputDecoration(
                    hintText: 'Your E-Wallet Number',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your E-Wallet number';
                    } else if (value.length < 11 || value.length > 13) {
                      return 'E-Wallet number must be between 11 to 13 digits';
                    }
                    return null; // Valid
                  },
                ),
                SizedBox(height: 310),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Collect all the data from controllers
                        signupController.setLoading(true);
                        try {
                          await signupController.registerUser(
                            email: signupController.emailController.text,
                            password: signupController.passwordController.text,
                            name: signupController.nameController.text,
                            area: signupController.areaController.text,
                            division: signupController.divisionController.text,
                            department:
                                signupController.departmentController.text,
                            address: signupController.addressController.text,
                            whatsappNumber:
                                signupController.whatsappNumberController.text,
                            ktpNumber:
                                signupController.ktpNumberController.text,
                            tShirtSize:
                                signupController.tshirtSizeController.text,
                            poloShirtSize:
                                signupController.poloShirtSizeController.text,
                            eWalletType: signupController.eWalletTypeController
                                .text = eWalletTypeController.text,
                            eWalletNumber: signupController
                                .eWalletNumberController
                                .text = eWalletNumberController.text,
                            context: context,
                            role: 'Participant',
                            status: 'Pending',
                          );
                          signupController.resetForm();
                        } catch (e) {
                          // Handle registration error
                        } finally {
                          signupController.setLoading(false);
                        }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
