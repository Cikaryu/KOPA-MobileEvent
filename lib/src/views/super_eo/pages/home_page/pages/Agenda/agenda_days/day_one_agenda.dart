import 'package:app_kopabali/src/core/base_import.dart';

class DayOneContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Friday, 20th September",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard("06.20 - 09.10", "Perjalanan Pesawat", [
          "Pastikan sudah mengubah tiket",
          "menjadi boarding pass dan datang",
          "tepat waktu",
          "",
        ]),
        _buildEventCard("09.10 - 09.30", "Mobilisasi Peserta", [
          "Peserta mendapatkan Participant",
          "Kit dan melanjutkan perjalanan",
          "menuju CSR"
        ]),
        _buildEventCard("09.30 - 10.00", "Perjalanan menuju Tempat CSR", [
          "Peserta akan dibagikan snack dan",
          "obat-obatan dibutuhkan saat",
          "diperjalanan"
        ]),
        _buildEventCard("10.00 - 12.00", "Kegiatan CSR"),
        _buildEventCard("12.00 - 13.00", "Makan Siang", [
          "Makan siang bersama di lokasi CSR",
          "dengan menu lokal khas daerah"
        ]),
        _buildEventCard("13.00 - 14.00", "Check-in hotel room"),
        _buildEventCard("19.00 - 21.00", "Welcome dinner", [
          "Acara makan malam bersama dan",
          "pengenalan agenda kegiatan",
          "selama trip berlangsung"
        ]),
        _buildEventCard("21.30", "Tiba di hotel",
            ["Istirahat dan persiapan untuk", "kegiatan esok hari"]),
      ],
    );
  }

  Widget _buildEventCard(String time, String title, [List<String>? details]) {
    return Card(
      color: HexColor("#EEEEEE"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (details != null && details.isNotEmpty) ...[
              SizedBox(height: 8),
              ...details.map(
                  (detail) => Text(detail, style: TextStyle(fontSize: 16))),
            ],
          ],
        ),
      ),
    );
  }
}
