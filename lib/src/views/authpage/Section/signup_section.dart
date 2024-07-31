import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/auth_controller.dart';

class SignupSection extends StatelessWidget {
  const SignupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageController>(
      init: LoginPageController(),
      builder: (controller) => Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text("Sign up"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: controller.tapSignIN,
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
                Text("Data Participant Kit", style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
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
                DropdownButtonFormField<String>(
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
                DropdownButtonFormField<String>(
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
                      style: TextStyle(color: Colors.grey[800], fontSize: 10),
                    ),
                    InkWell(
                      onTap: controller.tapSignIN,
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.blue[300], fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Sign UP", style: TextStyle(color: Colors.white)),
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
