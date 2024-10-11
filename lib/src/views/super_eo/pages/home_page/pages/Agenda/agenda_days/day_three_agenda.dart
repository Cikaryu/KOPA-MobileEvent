import 'package:flutter/material.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'Detail_agenda/AgendaDetailPage.dart';

class DayThreeContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Tuesday, 22nd October",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard(context, "06.00 - 07.00", "Sarapan Pagi", [
          "Sarapan terakhir di hotel",
          "Pengumpulan feedback kegiatan",
          "• Lokasi: Restoran utama hotel, lantai 1",
          "• Menu: Buffet internasional dengan pilihan makanan lokal",
          "• Feedback form akan dibagikan saat sarapan",
          "• Mohon mengisi feedback form sebelum check-out",
          "• Staff akan tersedia untuk membantu jika ada pertanyaan",
          "• Pastikan untuk tidak meninggalkan barang pribadi di restoran"
        ]),
        _buildEventCard(context, "07.00 - 08.00", "Room Check-out", [
          "Pastikan semua barang pribadi sudah dikemas dan tidak ada yang tertinggal",
          "• Periksa kembali:",
          "  - Laci dan lemari",
          "  - Kamar mandi",
          "  - Balkon atau teras (jika ada)",
          "  - Area penyimpanan di bawah tempat tidur",
          "• Kumpulkan kunci kamar dan kartu akses",
          "• Selesaikan tagihan tambahan (jika ada) di resepsi",
          "• Staff hotel tersedia untuk membantu dengan bagasi jika diperlukan",
          "• Informasikan resepsi jika ada barang yang tertinggal"
        ]),
        _buildEventCard(context, "08.00 - 09.00", "Luggage Drop", [
          "Kumpulkan koper di lobby hotel",
          "Staff akan mengantar ke bus",
          "• Area luggage drop: Lobby utama hotel",
          "• Pastikan label nama dan kontak terpasang pada setiap koper",
          "• Staff akan mendata dan menandai setiap koper",
          "• Simpan barang berharga dan dokumen penting dalam tas jinjing",
          "• Konfirmasi jumlah koper Anda dengan staff",
          "• Bus akan diparkir di area yang ditentukan untuk memudahkan loading"
        ]),
        _buildEventCard(context, "09.00 - 10.00", "Persiapan Keberangkatan", [
          "Briefing akhir dan pengumuman penting",
          "Pembagian snack untuk perjalanan",
          "• Lokasi briefing: Ruang konferensi hotel",
          "• Agenda briefing:",
          "  - Rekap kegiatan selama trip",
          "  - Informasi perjalanan ke bandara",
          "  - Pengumuman penting terkait penerbangan",
          "  - Sesi tanya jawab",
          "• Pembagian snack box:",
          "  - Sandwich atau wrap",
          "  - Buah-buahan segar",
          "  - Camilan ringan",
          "  - Air mineral",
          "• Pengecekan akhir daftar peserta"
        ]),
        _buildEventCard(context, "10.00 - 13.00", "Perjalanan ke Bandara", [
          "Perjalanan dengan bus",
          "Istirahat singkat di tengah perjalanan",
          "• Rute: Hotel - Jalan Bypass Ngurah Rai - Bandara Internasional Ngurah Rai",
          "• Estimasi waktu perjalanan: 3 jam (termasuk istirahat)",
          "• Fasilitas bus:",
          "  - AC",
          "  - Wi-Fi (jika tersedia)",
          "  - Toilet on-board",
          "• Istirahat singkat (15-20 menit):",
          "  - Lokasi: Area istirahat di tengah perjalanan",
          "  - Kesempatan untuk membeli makanan/minuman tambahan",
          "  - Tersedia toilet umum",
          "• Staff akan mengingatkan waktu keberangkatan setelah istirahat",
          "• Mohon tetap menjaga barang bawaan selama perjalanan"
        ]),
        _buildEventCard(context, "13.30", "Tiba di Bandara Jakarta", [
          "Check-in untuk penerbangan kembali",
          "Ucapan terima kasih dan perpisahan",
          "• Lokasi: Terminal Keberangkatan Bandara Internasional Soekarno-Hatta",
          "• Proses check-in:",
          "  - Staff akan membantu distribusi koper",
          "  - Pastikan dokumen perjalanan siap (KTP/Paspor, boarding pass)",
          "• Waktu check-in: Minimal 2 jam sebelum jadwal penerbangan",
          "• Pengingat keamanan bandara:",
          "  - Batasan cairan dalam bagasi kabin",
          "  - Barang yang dilarang dalam penerbangan",
          "• Ucapan terima kasih dan perpisahan dari panitia",
          "• Kontak darurat akan tetap aktif hingga semua peserta tiba di tujuan masing-masing",
          "• Mohon memberikan konfirmasi ketika sudah tiba di kota asal"
        ]),
      ],
    );
  }

  Widget _buildEventCard(
      BuildContext context, String time, String title, List<String> details) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AgendaDetailPage(time: time, title: title, details: details),
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
              Text(time,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
