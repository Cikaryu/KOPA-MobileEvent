import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_slide4_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SignupSlide3View extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tShirtSizeController = TextEditingController();
  final TextEditingController _poloShirtSizeController =
      TextEditingController();

  SignupSlide3View({super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment the following line if you need to use the SignupController.
    final SignupController signupController = Get.put(SignupController());
    final List<String> ukuranOptions = [
      'S',
      'M',
      'L',
      'XL',
      '2XL',
      '3XL',
      '4XL',
      '5XL'
    ];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Your Participant Kit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 10),
                Text('T-Shirt Size',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: 'Your T-Shirt Size',
                    hintStyle: TextStyle(color: Colors.grey),
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
                      width: 100,
                      offset: Offset(258, 55),
                      elevation: 5,
                      padding: EdgeInsets.all(10),
                      maxHeight: 240),
                  items: ukuranOptions.map((String ukuran) {
                    return DropdownMenuItem<String>(
                      value: ukuran,
                      child: Text(ukuran),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _tShirtSizeController.text = newValue!;
                  },
                  validator: (value) =>
                      value == null ? 'Please select a size' : null,
                ),
                SizedBox(height: 10),
                Text('Polo Shirt Size',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    hintText: 'Your Polo Shirt size',
                    hintStyle: TextStyle(color: Colors.grey),
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
                      width: 100,
                      offset: Offset(258, 55),
                      elevation: 5,
                      padding: EdgeInsets.all(10),
                      maxHeight: 240),
                  items: ukuranOptions.map((String ukuran) {
                    return DropdownMenuItem<String>(
                      value: ukuran,
                      child: Text(ukuran),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _poloShirtSizeController.text = newValue!;
                  },
                  validator: (value) =>
                      value == null ? 'Please select a size' : null,
                ),
                SizedBox(height: 310),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        signupController.tshirtSizeController.text =
                            _tShirtSizeController.text;
                        signupController.poloShirtSizeController.text =
                            _poloShirtSizeController.text;
                            signupController.nextPage();
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
                SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
