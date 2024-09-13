import 'package:app_kopabali/src/core/base_import.dart';

class DayThreeContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Sunday, 22nd September",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard("06.00 - 07.00", "Sarapan Pagi",
            ["Sarapan terakhir di hotel", "Pengumpulan feedback kegiatan"]),
        _buildEventCard("07.00 - 08.00", "Room Check-out", [
          "Pastikan semua barang pribadi sudah",
          "dikemas dan tidak ada yang tertinggal"
        ]),
        _buildEventCard("08.00 - 09.00", "Luggage Drop",
            ["Kumpulkan koper di lobby hotel", "Staff akan mengantar ke bus"]),
        _buildEventCard("09.00 - 10.00", "Persiapan Keberangkatan", [
          "Briefing akhir dan pengumuman penting",
          "Pembagian snack untuk perjalanan"
        ]),
        _buildEventCard("10.00 - 13.00", "Perjalanan ke Bandara", [
          "Perjalanan dengan bus",
          "Istirahat singkat di tengah perjalanan"
        ]),
        _buildEventCard("13.30", "Tiba di Bandara Jakarta", [
          "Check-in untuk penerbangan kembali",
          "Ucapan terima kasih dan perpisahan"
        ]),
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
