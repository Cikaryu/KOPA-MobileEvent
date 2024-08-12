import 'package:get/get.dart';

class FaqController extends GetxController {
  var faqs = <Map<String, String>>[
    {
      'question': 'What do we do?',
      'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    },
    {
      'question': 'How do we do it?',
      'answer': 'Vestibulum sit amet purus turpis. Donec consectetur...',
    },
    // Tambahkan lebih banyak FAQ di sini
  ].obs;

  var filteredFaqs = <Map<String, String>>[].obs;
  var expandedFaqIndexes = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    resetFaq();
    super.onClose();
  }

  void resetFaq() {
    filteredFaqs.value = faqs; // Reset ke semua FAQ
    expandedFaqIndexes.clear(); // Hapus semua indeks yang diperluas
  }

  void filterFaq(String query) {
    if (query.isEmpty) {
      filteredFaqs.value = faqs; // Show all FAQs if query is empty
    } else {
      filteredFaqs.value = faqs
          .where((faq) =>
              faq['question']!.toLowerCase().contains(query.toLowerCase()) ||
              faq['answer']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void toggleFaqExpansion(int index) {
    if (expandedFaqIndexes.contains(index)) {
      expandedFaqIndexes.remove(index);
    } else {
      expandedFaqIndexes.add(index);
    }
    update();
  }
}
