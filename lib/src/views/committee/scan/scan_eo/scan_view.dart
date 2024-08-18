
import 'package:app_kopabali/src/views/committee/scan/scan_eo/scan_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

//Function:
// TODO : button check all belum diimplementasikan
// TODO : dropdownbutton status tidak fetch ke database firebase ketika di referesh
// TODO : button save belum diimplementasikan
// TODO : dropdown promote belum diimplementasikan
// TODO : image profile belum di fetch

//Design : 
// TODO : desain dropdown promote belum fix
// TODO : desain item yang di dropdownbutton status belum fix
// TODO : App Bar terlihat ketika di scroll


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

    return RefreshIndicator(
      onRefresh: () async {
        await scanController.fetchUserData();
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: Get.width,
            child: Column(
              children: [
                // User profile
                Container(
                  width: 82,
                  height: 82,
                  decoration: ShapeDecoration(
                    image: scanController.imageBytes.value != null
                        ? DecorationImage(
                            image:
                                MemoryImage(scanController.imageBytes.value!),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    //dropdown for promote
                    SizedBox(
                      width: Get.width / 2.5,
                      child: DropdownButtonFormField2<String>(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(Icons.arrow_drop_down,
                              color: Colors.black45),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Choose',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'committe',
                            child: Text('Committee'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'eo',
                            child: Text(
                              'Event Organizer',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
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
                          padding: EdgeInsets.only(right: 16),
                          width: Get.width / 2.5,
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
                SizedBox(height: 16),
                // Dropdowncontainer MERCH
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Merch',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() {
                                    return Icon(
                                      scanController.isMerchExpanded.value
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_up_rounded,
                                      color: Colors.grey,
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(() {
                                return AnimatedContainer(
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
                                      ? 310
                                      : 0,
                                  curve: Curves.easeInOut,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 26),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Polo Shirt (${scanController.poloShirtSize.value})',
                                            'merchandise.poloShirt'),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'T-Shirt (${scanController.tShirtSize.value})',
                                            'merchandise.tShirt'),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Luggage Tag',
                                            'merchandise.luggageTag'),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Jas Hujan',
                                            'merchandise.jasHujan'),
                                        SizedBox(height: 20),
                                        Center(
                                            child: buildButtonCheckAll(
                                                scanController))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Dropdowncontainer SOUVENIR
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
                          scanController.tapSouvenir();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Souvenir',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() {
                                    return Icon(
                                      scanController.isSouvenirExpanded.value
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_up_rounded,
                                      color: Colors.grey,
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(() {
                                return AnimatedContainer(
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
                                  height:
                                      scanController.isSouvenirExpanded.value
                                          ? 230
                                          : 0,
                                  curve: Curves.easeInOut,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 26),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Gelang Tridatu',
                                            'souvenir.gelangTridatu'),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Selendang Udeng',
                                            'souvenir.selendangUdeng'),
                                        SizedBox(height: 20),
                                        buildButtonCheckAll(scanController)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Dropdowncontainer BENEFIT
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
                          scanController.tapBenefit();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Benefit',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() {
                                    return Icon(
                                      scanController.isBenefitExpanded.value
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_up_rounded,
                                      color: Colors.grey,
                                    );
                                  }),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(() {
                                return AnimatedContainer(
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
                                  height: scanController.isBenefitExpanded.value
                                      ? 230
                                      : 0,
                                  curve: Curves.easeInOut,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 26),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Voucher Belanja',
                                            'benefit.voucherEwallet'),
                                        SizedBox(height: 8),
                                        buildStatusRow(
                                            scanController,
                                            'Voucher E-Wallet',
                                            'benefit.voucherBelanja'),
                                        SizedBox(height: 20),
                                        buildButtonCheckAll(scanController)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("72BB65"),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
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

  //ButtonCheckall
  Widget buildButtonCheckAll(ScanController controller) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor("E97717"),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Check All',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Dropdown status
  Widget buildStatusRow(
      ScanController controller, String itemName, String field) {
    return Obx(() {
      final currentStatus = controller.status[field] ?? 'pending';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: TextStyle(fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color:
                    currentStatus == 'pending' ? Colors.yellow : Colors.green,
              ),
              color: Colors.grey[200],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: currentStatus == 'pending'
                    ? Icon(
                        Icons.timer,
                        size: 20,
                        color: Colors.yellow[600],
                      )
                    : Icon(
                        Icons.done,
                        size: 20,
                        color: Colors.green,
                      ),
                isDense: true,
                value: currentStatus,
                items: controller.statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.updateStatus(field, newValue);
                  }
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
