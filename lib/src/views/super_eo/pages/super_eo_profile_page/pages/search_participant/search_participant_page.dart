import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/participant_detail_page.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/search_participant_controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchParticipantPage extends StatelessWidget {
  const SearchParticipantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchParticipantController searchParticipantController =
        Get.put(SearchParticipantController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Search Participant',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: HexColor('01613B'),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Search field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: TextFormField(
                      controller: searchParticipantController.searchController,
                      onChanged: (value) {
                        searchParticipantController.searchParticipants(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter participant name',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // SizedBox(height: 11),
                        // Container(
                        //   width: 238,
                        //   height: 50,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 12, vertical: 15),
                        //   decoration: ShapeDecoration(
                        //     color: Color(0xFFF3F3F3),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color(0x3F000000),
                        //         blurRadius: 4,
                        //         offset: Offset(0, 0),
                        //         spreadRadius: 0,
                        //       )
                        //     ],
                        //   ),
                        //   child: Text(
                        //     'Categorize by attendence',
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 16,
                        //       fontFamily: 'Roboto',
                        //       fontWeight: FontWeight.w400,
                        //       height: 0,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 11),
                        GestureDetector(
                          onTap: () async {
                            searchParticipantController.toggleKitStatusFilter();
                          },
                          child: Container(
                            width: 280,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(),
                            ),
                            child: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: HexColor("E97717"),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.person)),
                                SizedBox(width: 10),
                                Text(
                                  'Categorize by Kit Status',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: searchParticipantController
                                            .isKitStatusFiltered.value
                                        ? HexColor("E97717")
                                        : Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 1,
                      color: Colors.black,
                      width: Get.width,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Sort by',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.swap_vert),
                          onPressed: () {
                            searchParticipantController.toggleSortOrder();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: searchParticipantController
                                .isKitStatusFiltered.value &&
                            searchParticipantController
                                .filteredParticipants.isEmpty
                        ? Center(
                            child: Text(
                              'No participants with closed kit status found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchParticipantController
                                .filteredParticipants.length,
                            itemBuilder: (context, index) {
                              final participant = searchParticipantController
                                  .filteredParticipants[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            participant.selfieUrl != null &&
                                                    participant
                                                        .selfieUrl!.isNotEmpty
                                                ? NetworkImage(
                                                    participant.selfieUrl!)
                                                : null,
                                        radius: 30,
                                        child: participant.selfieUrl == null ||
                                                participant.selfieUrl!.isEmpty
                                            ? Icon(Icons.person, size: 30)
                                            : null,
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              participant.name ?? 'Unknown',
                                              style: TextStyle(
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor('E97717'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ParticipantDetailPage(
                                                      participant: participant),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'View',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            if (searchParticipantController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(HexColor('E97717')),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
