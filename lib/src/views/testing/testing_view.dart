import 'package:app_kopabali/src/views/testing/testing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TestingView extends StatefulWidget {
  const TestingView({Key? key}) : super(key: key);

  @override
  TestingViewState createState() => TestingViewState();
}

class TestingViewState extends State<TestingView> {
  bool isScanning = true; // Status untuk mengatur apakah pemindaian aktif

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestingController>(
      init: TestingController(), // Inisialisasi controller
      builder: (testingController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Scan QR Code'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: isScanning
                    ? MobileScanner(
                        controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final String code = barcodes.first.rawValue ?? '';
                            testingController.setQRCodeResult(code);
                            setState(() {
                              isScanning = false;
                            });
                          }
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Result: ${testingController.qrCodeResult}'),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isScanning = true;
                                  testingController.clearQRCodeResult();
                                });
                              },
                              child: Text('Scan Another QR Code'),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
