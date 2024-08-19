// TODO : styling halaman search participant sesuaikan figma

import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/search_participant/search_participant_controller.dart';
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
        title: Text('Search Participant'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom pencarian
              TextField(
                controller: searchParticipantController.searchController,
                onChanged: (value) {
                  searchParticipantController.searchParticipants(value);
                },
                decoration: InputDecoration(
                  hintText: 'Enter participant name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  height: 2,
                  color: Colors.black,
                  width: Get.width,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'All Participants',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount:
                      searchParticipantController.filteredParticipants.length,
                  itemBuilder: (context, index) {
                    final participant =
                        searchParticipantController.filteredParticipants[index];
                    return Container(
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
                            offset: Offset(
                                0, 2), // Changes the position of the shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: participant.selfieUrl != null &&
                                    participant.selfieUrl!.isNotEmpty
                                ? NetworkImage(participant.selfieUrl!)
                                : null,
                            radius: 30,
                            child: participant.selfieUrl == null ||
                                    participant.selfieUrl!.isEmpty
                                ? Icon(Icons.person,
                                    size:
                                        30) // Menampilkan ikon jika tidak ada gambar
                                : null,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  participant.name ?? 'Unknown',
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(onPressed: () {}, child: Text('Edit')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
