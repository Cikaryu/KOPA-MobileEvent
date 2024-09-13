import 'package:app_kopabali/src/core/base_import.dart';

class DayTwoContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Saturday, 21st September",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard("07.00 - 08.00", "Sarapan Pagi", [
          "Sarapan bersama di restoran hotel",
          "Briefing singkat tentang kegiatan hari ini"
        ]),
        _buildEventCard("09.00 - 12.00", "Team Building", [
          "Lokasi: Pantai/Area Outdoor Hotel",
          "Aktivitas: Ice breaking, problem-solving",
          "games, dan trust-building exercises"
        ]),
        _buildEventCard("12.00 - 13.00", "Makan Siang", [
          "Makan siang bersama di lokasi kegiatan",
          "Menu: Hidangan lokal khas Bali"
        ]),
        _buildEventCard("13.00 - 16.00", "Waktu Bebas", [
          "Istirahat atau eksplorasi area sekitar",
          "Persiapan untuk Gala Dinner"
        ]),
        _buildEventCard("19.00 - 22.00", "Gala Dinner", [
          "Lokasi: Ballroom Hotel",
          "Dress code: Formal atau Batik",
          "Acara: Makan malam, hiburan, dan",
          "pemberian penghargaan"
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
