import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/testing/testing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class TestingView extends StatefulWidget {
  const TestingView({super.key});

  @override
  TestingViewState createState() => TestingViewState();
}

class TestingViewState extends State<TestingView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestingController>(
      builder: (testingController) => PopScope(
        canPop: testingController.canPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (QRViewController qrController) {
                    this.controller = qrController;
                    qrController.scannedDataStream.listen((scanData) {
                      testingController.setQRCodeResult(scanData.code!);
                      Get.snackbar("QR Code Result", scanData.code!);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (testingController.qrCodeResult != null)
                      ? Text('Result: ${testingController.qrCodeResult}')
                      : Text('Scan a code'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
