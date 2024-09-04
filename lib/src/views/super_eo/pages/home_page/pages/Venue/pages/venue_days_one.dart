import 'package:app_kopabali/src/core/base_import.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
          youtubeUrl: 'https://www.youtube.com/watch?v=KQ-StN4-WPE',
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
  late bool _isFullScreen;

  @override
  void initState() {
    super.initState();
    _isFullScreen = false;
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: true,
        disableDragSeek: true,
        showLiveFullscreenButton: false,
      ),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen && !_isFullScreen) {
      _isFullScreen = true;
      _enterFullScreenLandscape();
    } else if (!_controller.value.isFullScreen && _isFullScreen) {
      _isFullScreen = false;
      _exitFullScreenLandscape();
    }
  }

  void _enterFullScreenLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide system UI for full immersive experience
  }

  void _exitFullScreenLandscape() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Restore system UI
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9, // Maintain a 16:9 aspect ratio
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              onReady: () {
                print('Player is ready.');
              },
              onEnded: (YoutubeMetaData metaData) {
                _controller.pause(); // Ensure video stops when it ends
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
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