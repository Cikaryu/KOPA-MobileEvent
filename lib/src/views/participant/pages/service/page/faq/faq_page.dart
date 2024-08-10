//TODO: Update FAQ Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/faq/faq_controller.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqController faqController = Get.put(FaqController(), tag: 'faq');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Frequently Asked Questions',
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search),
                hintText: 'Search FAQ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                faqController.filterFaq(query);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: faqController.filteredFaqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqController.filteredFaqs[index];
                    final isExpanded =
                        faqController.expandedFaqIndexes.contains(index);

                    return InkWell(
                      onTap: () {
                        faqController.toggleFaqExpansion(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: HexColor('F3F3F3'),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  faq['question'] ?? 'No Question Available',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_down_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              SizedBox(height: 8),
                              Text(
                                faq['answer'] ?? 'No Answer Available',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
