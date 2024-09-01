import 'package:app_kopabali/src/core/base_import.dart';

class VenuePagedayone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Friday, 20th September", style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 8),
        VenueCard(
          assetPath: 'assets/images/bali.png',
          title: 'Venue 1',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet id sapien quis suscipit. Etiam ultrices libero purus, at accumsan dolor condimentum sit amet.',
        ),
        SizedBox(height: 16),
        VenueCard(
          assetPath: 'assets/images/bali.png',
          title: 'Venue 2',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet id sapien quis suscipit. Etiam ultrices libero purus, at accumsan dolor condimentum sit amet.',
        ),
      ],
    );
  }
}

class VenueCard extends StatelessWidget {
  final String assetPath;
  final String title;
  final String description;

  const VenueCard({
    Key? key,
    required this.assetPath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Image.asset(
                  assetPath,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 45,
                left: (MediaQuery.of(context).size.width / 2) - 55,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
