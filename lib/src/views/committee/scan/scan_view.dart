import 'package:app_kopabali/src/views/committee/scan/scan_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    final ScanController scanController = Get.put(ScanController());
    String? selectedValue;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: Get.width,
          child: Column(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: ShapeDecoration(
                  image: scanController.imageBytes.value != null
                      ? DecorationImage(
                          image: MemoryImage(scanController.imageBytes.value!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  shape: OvalBorder(),
                ),
                child: scanController.imageBytes.value == null
                    ? Icon(Icons.person, size: 82, color: Colors.grey[500])
                    : null,
              ),
              SizedBox(height: 16),
              Obx(() => Text(
                    scanController.userName.value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )),
              Obx(() => Text(
                    scanController.userDivisi.value,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Promote",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: Get.width / 3,
                    child: DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon:
                            Icon(Icons.arrow_drop_down, color: Colors.black45),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Choose',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'committe',
                          child: Text('Committee'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'eo',
                          child: Text('Event Organizer'),
                        ),
                      ],
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 40,
                        padding: EdgeInsets.zero,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(null),
                        iconSize: 0,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        padding: EdgeInsets.only(left: 16, right: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: HexColor('F3F3F3'),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        scanController.tapMerch();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Merch',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  scanController.isMerchExpanded.value
                                      ? Icons.keyboard_arrow_down_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            AnimatedContainer(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              width: 300,
                              duration: Duration(milliseconds: 300),
                              height: scanController.isMerchExpanded.value
                                  ? 240
                                  : 0,
                              curve: Curves.easeInOut,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Polo Shirt (${scanController.poloShirtSize.value})',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Obx(() {
                                          final imageUrl =
                                              scanController.statusImageUrls[
                                                      'poloShirt'] ??
                                                  '';

                                          if (imageUrl.isEmpty) {
                                            return Icon(Icons
                                                .error); // Menampilkan ikon error jika gambar gagal diambil
                                          }
                                          return Image.network(
                                            imageUrl,
                                            width: 24,
                                            height: 24,
                                          ); // Menampilkan gambar status jika berhasil diambil
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'T-Shirt (${scanController.tShirtSize.value})',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Obx(() {
                                          final imageUrl = scanController
                                                  .statusImageUrls['tShirt'] ??
                                              '';

                                          if (imageUrl.isEmpty) {
                                            return Icon(Icons
                                                .error); // Menampilkan ikon error jika gambar gagal diambil
                                          }
                                          return Image.network(
                                            imageUrl,
                                            width: 24,
                                            height: 24,
                                          ); // Menampilkan gambar status jika berhasil diambil
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Luggage Tag',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Obx(() {
                                          final imageUrl =
                                              scanController.statusImageUrls[
                                                      'luggageTag'] ??
                                                  '';

                                          if (imageUrl.isEmpty) {
                                            return Icon(Icons
                                                .error); // Menampilkan ikon error jika gambar gagal diambil
                                          }
                                          return Image.network(
                                            imageUrl,
                                            width: 24,
                                            height: 24,
                                          ); // Menampilkan gambar status jika berhasil diambil
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Jas Hujan',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Obx(() {
                                          final imageUrl =
                                              scanController.statusImageUrls[
                                                      'jasHujan'] ??
                                                  '';

                                          if (imageUrl.isEmpty) {
                                            return Icon(Icons
                                                .error); // Menampilkan ikon error jika gambar gagal diambil
                                          }
                                          return Image.network(
                                            imageUrl,
                                            width: 24,
                                            height: 24,
                                          ); // Menampilkan gambar status jika berhasil diambil
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
