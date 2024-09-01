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
          child: Text("Friday, 22th September", style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 8),
        _buildEventCard("09.10 - 09.30", "Mobilisasi Peserta", [
          "Jas Hujan",
          "Polo Shirt",
          "Luggage Tag",
          "T-Shirt",
          "Name Tag",
        ]),
        SizedBox(height: 16),
        _buildEventCard("09.30 - 10.00", "Perjalanan menuju Tempat CSR", [
          "Example",
          "Example",
          "Example",
          "Example",
          "Example",
        ]),
      ],
    );
  }

  Widget _buildEventCard(String time, String title, List<String> items) {
    return Card(
      color: HexColor("#EEEEEE"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 18)),
            SizedBox(height: 4),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Icon(Icons.circle, size: 20, color: HexColor("#01613B")),
                  title: Text(items[index]),
                  horizontalTitleGap: 4,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
