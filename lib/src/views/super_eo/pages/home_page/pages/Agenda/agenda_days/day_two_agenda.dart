import 'package:flutter/material.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'Detail_agenda/AgendaDetailPage.dart';

class DayTwoContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Monday, 21st October",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard(context, "07.00 - 08.00", "Sarapan Pagi", [
          "Sarapan bersama di restoran hotel",
          "Briefing singkat tentang kegiatan hari ini",
          "• Lokasi: Restoran utama hotel, lantai 1",
          "• Menu: Buffet internasional dengan pilihan makanan lokal",
          "• Dress code: Kasual",
          "• Poin-poin briefing:",
          "  - Jadwal kegiatan hari ini",
          "  - Perlengkapan yang perlu disiapkan",
          "  - Pengumuman penting lainnya",
          "• Peserta diharapkan hadir tepat waktu untuk briefing"
        ]),
        _buildEventCard(context, "09.00 - 12.00", "Team Building", [
          "Lokasi: Pantai/Area Outdoor Hotel",
          "Aktivitas: Ice breaking, problem-solving games, dan trust-building exercises",
          "• Pembagian kelompok: 5-6 orang per tim",
          "• Aktivitas ice breaking (30 menit):",
          "  - Perkenalan kreatif",
          "  - Permainan nama dan gerakan",
          "• Problem-solving games (90 menit):",
          "  - Tantangan menara marshmallow",
          "  - Teka-teki tim",
          "  - Misi penyelamatan simulasi",
          "• Trust-building exercises (60 menit):",
          "  - Trust fall",
          "  - Navigasi buta",
          "  - Lingkaran kepercayaan",
          "• Debrief dan refleksi (30 menit)",
          "• Perlengkapan: Topi, sunscreen, air minum",
          "• Pakaian: Baju olahraga atau kasual yang nyaman"
        ]),
        _buildEventCard(context, "12.00 - 13.00", "Makan Siang", [
          "Makan siang bersama di lokasi kegiatan",
          "Menu: Hidangan lokal khas Bali",
          "• Lokasi: Area piknik outdoor dekat pantai",
          "• Menu:",
          "  - Nasi Campur Bali",
          "  - Ayam Betutu",
          "  - Lawar",
          "  - Sate Lilit",
          "  - Jukut Ares",
          "  - Sambal Matah",
          "  - Buah-buahan segar",
          "  - Minuman: Es Daluman, Air Mineral",
          "• Akomodasi untuk kebutuhan diet khusus tersedia",
          "• Waktu untuk bersantai dan networking informal"
        ]),
        _buildEventCard(context, "13.00 - 16.00", "Waktu Bebas", [
          "Istirahat atau eksplorasi area sekitar",
          "Persiapan untuk Gala Dinner",
          "• Aktivitas opsional:",
          "  - Relaksasi di pantai",
          "  - Menggunakan fasilitas hotel (spa, gym, kolam renang)",
          "  - Eksplorasi area sekitar hotel (dengan panduan)",
          "• Tips persiapan Gala Dinner:",
          "  - Waktu yang cukup untuk bersiap-siap",
          "  - Periksa dress code",
          "  - Siapkan aksesoris atau perlengkapan tambahan jika diperlukan",
          "• Layanan concierge tersedia untuk informasi aktivitas lokal"
        ]),
        _buildEventCard(context, "19.00 - 22.00", "Gala Dinner", [
          "Lokasi: Ballroom Hotel",
          "Dress code: Formal atau Batik",
          "Acara: Makan malam, hiburan, dan pemberian penghargaan",
          "• Rundown acara:",
          "  - 19.00 - 19.30: Cocktail reception",
          "  - 19.30 - 19.45: Pembukaan dan sambutan",
          "  - 19.45 - 20.30: Makan malam",
          "  - 20.30 - 21.15: Pertunjukan budaya Bali",
          "  - 21.15 - 21.45: Pemberian penghargaan",
          "  - 21.45 - 22.00: Penutupan",
          "• Menu: Fusion Bali-Internasional (termasuk pilihan vegetarian)",
          "• Hiburan: Tari tradisional Bali, musik live",
          "• Photobooth tersedia untuk dokumentasi",
          "• Pengumuman penting untuk kegiatan hari berikutnya"
        ]),
      ],
    );
  }

 Widget _buildEventCard(BuildContext context, String time, String title, List<String> details) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgendaDetailPage(time: time, title: title, details: details),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: HexColor("#EEEEEE"),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (details.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                details.first,
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}