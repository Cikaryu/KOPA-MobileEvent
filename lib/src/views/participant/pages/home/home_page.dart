import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/home/home_page_controller.dart';
import 'package:app_kopabali/src/views/participant/pages/home/pages/Agenda/participant_agenda_view.dart';

import 'pages/Participant_Benefit/participant_Benefit_view.dart';
import 'pages/participant_kit/participant_kit.dart';

class HomePageParticipant extends StatefulWidget {
  @override
  State<HomePageParticipant> createState() => _HomePageParticipantState();
}

class _HomePageParticipantState extends State<HomePageParticipant> {
  @override
  Widget build(BuildContext context) {
    final HomePageParticipantController homePageController =
        Get.put(HomePageParticipantController());
    return SafeArea(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20.0), // Apply radius here
                    ),
                    child: Container(
                      color: HexColor('#01613B'), // Background color of AppBar
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text(
                              'Hello, ${homePageController.userName.value}!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
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
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 150),
                        Text(
                          'Employee Gathering\nElnusa Petrofin 2024',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#01613B'),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Event Tagline',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                      vertical: 22, horizontal: 27),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.event,
                                          size: 32, color: HexColor('#E97717')),
                                      SizedBox(height: 8),
                                      Text(
                                        'Agenda',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                                        builder: (context) => ParticipantKit()),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.card_giftcard,
                                          size: 32, color: HexColor('#E97717')),
                                      SizedBox(height: 8),
                                      Text(
                                        'Participant\nKit',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.emoji_events,
                                          size: 32, color: HexColor('#E97717')),
                                      SizedBox(height: 8),
                                      Text(
                                        'Participant\nBenefit',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
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
                        SizedBox(height: 34),
                        Container(
                          width: 329,
                          height: 180,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://d3p0bla3numw14.cloudfront.net/news-content/img/2021/05/03112735/Tempat-Tinggal-Terbaik-di-Bali.jpg"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
                              IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.arrow_circle_right_sharp,
                                    color: HexColor("#01613B"),
                                    size: 50,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
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
                                Text(
                                  'Event Date',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
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
                                    color: HexColor('#01613B'),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Event Live Countdown',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
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
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
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
                        SizedBox(height: 160),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              Text(
                                'From Our Head of \nCommittee',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#01613B'),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at nulla massa. Pellentesque faucibus mauris posuere, aliquet leo vel, vulputate sapien.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 16),
                              CircleAvatar(
                                radius: 50,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Martin Siphron',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#01613B'),
                                ),
                              ),
                              Text(
                                'Head of Committee',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 120),
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
