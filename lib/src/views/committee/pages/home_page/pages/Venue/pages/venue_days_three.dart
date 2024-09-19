import 'package:app_kopabali/src/core/base_import.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VenuePagedaythree extends StatelessWidget {
  const VenuePagedaythree({super.key});

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
          youtubeUrl: 'https://www.youtube.com/watch?v=6h8t79wbX9U',
          title: 'Venue 1',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet id sapien quis suscipit. Etiam ultrices libero purus, at accumsan dolor condimentum sit amet.',
        ),
        SizedBox(height: 16),
        VenueCard(
          youtubeUrl: 'https://www.youtube.com/watch?v=ov6tinrcsdI',
          title: 'Venue 2',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin imperdiet id sapien quis suscipit. Etiam ultrices libero purus, at accumsan dolor condimentum sit amet.',
        ),
      ],
    );
  }
}

class VenueCard extends StatefulWidget {
  final String youtubeUrl;
  final String title;
  final String description;

  const VenueCard({
    Key? key,
    required this.youtubeUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _VenueCardState createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
        enableCaption: false,
        hideControls: false,
        hideThumbnail: false,
        showLiveFullscreenButton: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap the YoutubePlayer widget in ClipRRect to apply border radius
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Set your desired radius here
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                onReady: () {
                  print('Player siap.');
                },
                onEnded: (YoutubeMetaData metaData) {
                  _controller.pause();
                },
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  RemainingDuration(),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
