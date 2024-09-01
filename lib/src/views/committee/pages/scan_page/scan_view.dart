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
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            // Background container with opacity
            Positioned.fill(
              child: MobileScanner(
                fit: BoxFit.cover,
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
            ),
            // Overlay with gradient
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius:
                          0.6, // Adjust to change the size of the clear area
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(
                            0.5), // Gradient color and opacity for the edges
                      ],
                      stops: [
                        0.5,
                        1.0
                      ], // Adjust to control where the gradient transitions
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
                  onDetect: (barcodeCapture) {
                    final Barcode? barcode = barcodeCapture.barcodes.first;
                    if (barcode?.rawValue != null) {
                      final String qrCode = barcode!.rawValue!;
                      qrCodeController.processQRCode(qrCode).then((_) {
                        // Navigation handled in processQRCode
                      }).catchError((error) {
                        print('Error in QR code processing: $error');
                        Get.snackbar("Error", "Failed to process QR code.");
                      });
                    } else {
                      Get.snackbar("Error", "Failed to scan QR code.");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
