import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'log_item.dart';

class DataLogsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<LogItem> logs = <LogItem>[].obs;
  final RxString filter = 'newest'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  void fetchLogs() async {
    logs.clear();
    await Future.wait([
      _fetchRoleChanges(),
      _fetchKitStatusChanges(),
      _fetchReportReplies(),
    ]);
    _sortLogs();
  }

  Future<void> _fetchRoleChanges() async {
    // Fetch all users who have been promoted to any role
    QuerySnapshot roleChanges = await _firestore.collection('users').get();

    for (var doc in roleChanges.docs) {
      String userName = doc['name']; // The name of the user who got promoted
      String role = doc['role']; // The role they were promoted to

      // Log all role changes, not just Super EO
      logs.add(LogItem(
        date: (doc['updatedAt'] as Timestamp).toDate(),
        action: '$userName has been promoted to $role by $userName',
      ));
    }
  }

  Future<void> _fetchKitStatusChanges() async {
    QuerySnapshot kitChanges =
        await _firestore.collection('participantKit').get();

    for (var doc in kitChanges.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['merchandise'] != null) {
        Map<String, dynamic> merchandise = data['merchandise'];
        merchandise.forEach((itemName, itemDetails) {
          DateTime logDate =
              (itemDetails['updatedAt'] as Timestamp?)?.toDate() ??
                  DateTime.now();
          logs.add(LogItem(
              date: logDate,
              action:
                  'Participant Kit $itemName status changed to ${itemDetails['status']}'));
        });
      }
    }
  }

  Future<void> _fetchReportReplies() async {
    QuerySnapshot reportReplies = await _firestore
        .collection('report')
        .where('status', isNotEqualTo: 'Unresolved')
        .get();

    for (var doc in reportReplies.docs) {
      logs.add(LogItem(
          date: (doc['updatedAt'] as Timestamp).toDate(),
          action: 'Report "${doc['title']}" was replied by'));
    }
  }

  void _sortLogs() {
    logs.sort((a, b) => filter.value == 'newest'
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));
  }

  void changeFilter(String? value) {
    if (value != null) {
      filter.value = value;
      _sortLogs();
    }
  }
}
