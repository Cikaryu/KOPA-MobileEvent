import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:app_kopabali/src/views/committee/pages/scan_page/scan_controller.dart';

class ScannerView extends StatelessWidget {
  final ScanController scanController = Get.put(ScanController());

  ScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Obx(() => scanController.isCameraActive.value
          ? _buildScannerBody()
          : Center(child: Text('Camera is inactive'))),
    );
  }

  Widget _buildScannerBody() {
    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              fit: BoxFit.cover,
              onDetect: _handleDetection,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.6,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: Get.width / 1.2,
              height: 360,
              child: MobileScanner(
                fit: BoxFit.cover,
                onDetect: _handleDetection,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDetection(BarcodeCapture barcodeCapture) {
    final Barcode? barcode = barcodeCapture.barcodes.first;
    if (barcode?.rawValue != null) {
      final String qrCode = barcode!.rawValue!;
      scanController.processQRCode(qrCode);
    } else {
      Get.snackbar("Error", "Failed to scan QR code.");
    }
  }
}