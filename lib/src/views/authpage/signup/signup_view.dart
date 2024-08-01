// ignore_for_file: sort_child_properties_last

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) => Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text("Sign up"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: controller.tapSignin,
          ),
          backgroundColor: Color(0xFFF5F5F5),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text("Data Pribadi", style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Nama",
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Area",
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Divisi",
                    prefixIcon: Icon(Icons.work),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Department",
                    prefixIcon: Icon(Icons.business),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Alamat",
                    prefixIcon: Icon(Icons.home),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Nomor Whatsapp",
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Nomor KTP",
                    prefixIcon: Icon(Icons.credit_card),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 210,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person, size: 100, color: Colors.grey[500]),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Foto Diri",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 210,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person, size: 100, color: Colors.grey[500]),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Foto KTP",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Data Participant Kit", style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: "Ukuran T-Shirt",
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
                    offset: Offset(252, 55),
                    elevation: 5,
                    padding: EdgeInsets.all(10),
                  ),
                  value: null,
                  items: [
                    DropdownMenuItem(
                      value: "S",
                      child: Text("S"),
                    ),
                    DropdownMenuItem(
                      value: "M",
                      child: Text("M"),
                    ),
                    DropdownMenuItem(
                      value: "L",
                      child: Text("L"),
                    ),
                    DropdownMenuItem(
                      value: "XL",
                      child: Text("XL"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: "Ukuran Polo Shirt",
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
                    offset: Offset(252, 55),
                    elevation: 5,
                    padding: EdgeInsets.all(10),
                  ),
                  value: null,
                  items: [
                    DropdownMenuItem(
                      value: "S",
                      child: Text("S"),
                    ),
                    DropdownMenuItem(
                      value: "M",
                      child: Text("M"),
                    ),
                    DropdownMenuItem(
                      value: "L",
                      child: Text("L"),
                    ),
                    DropdownMenuItem(
                      value: "XL",
                      child: Text("XL"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                Text("Data Benefit", style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: "E-wallet",
                    prefixIcon: Icon(Icons.account_balance_wallet),
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
                    width: 150,
                    offset: Offset(202, 55),
                    elevation: 5,
                    padding: EdgeInsets.all(10),
                  ),
                  value: null,
                  items: [
                    DropdownMenuItem(
                      value: "OVO",
                      child: Text("OVO"),
                    ),
                    DropdownMenuItem(
                      value: "GoPay",
                      child: Text("GoPay"),
                    ),
                    DropdownMenuItem(
                      value: "Dana",
                      child: Text("Dana"),
                    ),
                    DropdownMenuItem(
                      value: "ShopeePay",
                      child: Text("ShopeePay"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Nomor E-Wallet",
                    prefixIcon: Icon(Icons.credit_card),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey[800], fontSize: 12),
                    ),
                    InkWell(
                      onTap: controller.tapSignin,
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.blue[300], fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Sign up", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    padding:
                        EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
