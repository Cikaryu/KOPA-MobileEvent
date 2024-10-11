import 'package:flutter/material.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'Detail_agenda/AgendaDetailPage.dart';

class DayOneContentAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Sunday, 20th October",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 8),
        _buildEventCard(context, "06.20 - 09.10", "Perjalanan Pesawat", [
          "Prosedur perjalanan pesawat dimulai dengan check-in di bandara, diikuti pemeriksaan keamanan. Setelah itu, penumpang menunggu di ruang keberangkatan hingga panggilan boarding.",
          "Saat boarding, penumpang menunjukkan boarding pass, masuk ke pesawat, dan duduk sesuai nomor kursi sebelum pesawat lepas landas.",
          "Dokumen Perjalanan:",
          "• Bawa KTP atau paspor yang masih berlaku.",
          "• Siapkan boarding pass (cetak atau di ponsel).",
          "• Pastikan visa perjalanan sudah siap untuk perjalanan internasional.",
          "Waktu Kedatangan:",
          "• Datang lebih awal: minimal 2 jam sebelum penerbangan domestik dan 3 jam untuk penerbangan internasional.",
          "Barang Penting:",
          "• Bawa barang penting di dalam tas kabin:",
          "  - Obat-obatan",
          "  - Ponsel dan charger",
          "  - Cairan ukuran travel (maksimal 100ml, dalam kantong plastik transparan)",
          "• Pastikan bagasi terdaftar Anda memenuhi batas berat dan ukuran dari maskapai penerbangan.",
          "Pemeriksaan Keamanan:",
          "• Perhatikan barang-barang terlarang (misalnya, benda tajam, cairan dalam jumlah besar) di dalam tas kabin.",
          "• Siapkan diri untuk aturan cairan: semua cairan, gel, dan aerosol harus dalam wadah maksimal 100ml dan disiapkan dalam kantong plastik transparan.",
          "Saat di Pesawat:",
          "• Simpan boarding pass dan KTP/paspor di tempat yang mudah diakses.",
          "• Ikuti instruksi kru selama boarding dan prosedur keamanan.",
        ]),
        _buildEventCard(context, "09.10 - 09.30", "Mobilisasi Peserta", [
          "Peserta mendapatkan Participant Kit dan melanjutkan perjalanan menuju CSR",
          "• Pengambilan Participant Kit di lokasi yang ditentukan",
          "• Pengarahan singkat tentang agenda CSR",
          "• Pembagian kelompok jika diperlukan",
          "• Persiapan perlengkapan untuk kegiatan CSR"
        ]),
        _buildEventCard(
            context, "09.30 - 10.00", "Perjalanan menuju Tempat CSR", [
          "Peserta akan dibagikan snack dan obat-obatan dibutuhkan saat diperjalanan",
          "• Pengecekan kehadiran peserta",
          "• Pembagian snack dan air minum",
          "• Informasi tentang rute perjalanan",
          "• Pengarahan singkat tentang lokasi CSR",
          "• Pengingat untuk membawa perlengkapan pribadi"
        ]),
        _buildEventCard(context, "10.00 - 12.00", "Kegiatan CSR", [
          "• Sambutan dan pengarahan dari koordinator CSR",
          "• Pembagian tugas dan area kerja",
          "• Pelaksanaan kegiatan CSR sesuai rencana",
          "• Dokumentasi kegiatan",
          "• Evaluasi singkat setelah kegiatan selesai"
        ]),
        _buildEventCard(context, "12.00 - 13.00", "Makan Siang", [
          "Makan siang bersama di lokasi CSR dengan menu lokal khas daerah",
          "• Penyajian menu lokal khas daerah",
          "• Waktu untuk beristirahat dan bersosialisasi",
          "• Pengarahan singkat untuk kegiatan selanjutnya"
        ]),
        _buildEventCard(context, "13.00 - 14.00", "Check-in hotel room", [
          "• Penerimaan kunci kamar di resepsi hotel",
          "• Penjelasan fasilitas hotel",
          "• Waktu untuk merapikan barang bawaan",
          "• Informasi jadwal kegiatan selanjutnya"
        ]),
        _buildEventCard(context, "19.00 - 21.00", "Welcome dinner", [
          "Acara makan malam bersama dan pengenalan agenda kegiatan selama trip berlangsung",
          "• Sambutan dari panitia",
          "• Perkenalan seluruh peserta",
          "• Presentasi agenda kegiatan selama trip",
          "• Sesi tanya jawab",
          "• Networking dan sosialisasi antar peserta"
        ]),
        _buildEventCard(context, "21.30", "Tiba di hotel", [
          "Istirahat dan persiapan untuk kegiatan esok hari",
          "• Pengumuman waktu berkumpul untuk esok hari",
          "• Pengingat untuk mempersiapkan perlengkapan untuk kegiatan besok",
          "• Waktu bebas untuk beristirahat"
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
