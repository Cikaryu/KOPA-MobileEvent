import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/home_page/home_page_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'pages/Agenda/participant_agenda_view.dart';
import 'pages/Participant_Benefit/participant_Benefit_view.dart';
import 'pages/Venue/venue.dart';
import 'pages/participant_kit/participant_kit.dart';

class HomePageSuperEO extends StatefulWidget {
  @override
  State<HomePageSuperEO> createState() => _HomePageParticipantState();
}

class _HomePageParticipantState extends State<HomePageSuperEO> {
  @override
  Widget build(BuildContext context) {
    final HomePageSuperEOController homePageController =
        Get.put(HomePageSuperEOController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () {
            int days = homePageController.duration.value.inDays;
            int hours = homePageController.duration.value.inHours.remainder(24);
            int minutes =
                homePageController.duration.value.inMinutes.remainder(60);
            int seconds =
                homePageController.duration.value.inSeconds.remainder(60);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.1810, // Set height according to your need
                    color: HexColor('#727578'), // Background color of AppBar
                    padding: EdgeInsets.fromLTRB(16.0,
                        MediaQuery.of(context).padding.top + 20.0, 16.0, 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  'Hello, ${homePageController.userName.value}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: HexColor("#FFFFFF").withOpacity(0.5),
                                    overflow: TextOverflow.visible,
                                  ),
                                )),
                            Text(
                              " !",
                              style: TextStyle(
                                fontSize: 20,
                                color: HexColor("#FFFFFF").withOpacity(0.5),
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Welcome To Your Homepage',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/evenyt.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                      SizedBox(height: 22),
                      Text(
                        'Your - Event - Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: HexColor('#E97717'),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Event Tagline',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.06, // 6% of the screen height
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ParticipantKit()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: HexColor("F2F2F2"),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_gift.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Participant\nKit',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ParticipantBenefitView()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: HexColor("F2F2F2"),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_user_add.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Participant\nBenefit',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ParticipantAgendaView()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: HexColor("F2F2F2"),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_calendar_range.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Agenda\nKegiatan\t\t\t\t',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.034),
                      Container(
                        width: Get.width,
                        height: MediaQuery.of(context).size.height *
                            0.225, // 22.5% of the screen height
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bali.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome To Bali",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => VenueViewPage()),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFE97717),
                                  shape: OvalBorder(),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Icon(Icons.navigate_next_outlined,
                                    color: Colors.white, size: 43),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.1175, // 11.75% of the screen height
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        //container time countdown
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 29),
                          child: Container(
                            padding: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_calendar_fill.svg',
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Event Date',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '20 - 23 September 2024',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: HexColor('#727578'),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_time.svg',
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Event Live Countdown',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                '$days',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Days',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '$hours',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Hours',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '$minutes',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Minutes',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '$seconds',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Seconds',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 56.0),
                          child: Column(
                            children: [
                              Text(
                                'From Our Head of \nCommittee',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#E97717'),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at nulla massa. Pellentesque faucibus mauris posuere, aliquet leo vel, vulputate sapien.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 26),
                              Image.asset(
                                'assets/images/headcommittee.png',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Martin Siphron',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#E97717'),
                                ),
                              ),
                              Text(
                                'Head of Committee',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                        Text(
                          'Event Highlights',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#E97717'),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: VenueCard(
                            youtubeUrl:
                                'https://www.youtube.com/watch?v=Kvp9sOnZZ7U',
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VenueCard extends StatefulWidget {
  final String youtubeUrl;

  const VenueCard({
    Key? key,
    required this.youtubeUrl,
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
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20), // Set your desired radius here
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                aspectRatio: 16 / 9,
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
        ],
      ),
    );
  }
}
