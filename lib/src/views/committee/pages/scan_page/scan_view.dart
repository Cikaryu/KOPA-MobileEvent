import 'package:app_kopabali/src/views/committee/pages/scan_page/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatelessWidget {
  final ScanController qrCodeController = Get.put(ScanController());

  ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final Barcode? barcode = barcodeCapture.barcodes.first;
          if (barcode?.rawValue != null) {
            final String qrCode = barcode!.rawValue!;
            qrCodeController.processQRCode(qrCode);
          } else {
            Get.snackbar("Error", "Failed to scan QR code.");
          }
        },
      ),
    );
  }
}
