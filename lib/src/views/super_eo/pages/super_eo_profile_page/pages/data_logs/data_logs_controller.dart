import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'log_item.dart';

class DataLogsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<LogItem> logs = <LogItem>[].obs;
  final RxList<LogItem> filteredLogs = <LogItem>[].obs;
  final RxString filter = 'newest'.obs;
  final RxString searchQuery = ''.obs;
  late StreamSubscription<QuerySnapshot> _logsSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToLogs();
  }

  @override
  void onClose() {
    _logsSubscription.cancel();
    super.onClose();
  }

  void _listenToLogs() {
    try {
      _logsSubscription =
          _firestore.collection('activityLogs').snapshots().listen((snapshot) {
            logs.clear();
            if (snapshot.docs.isEmpty) {
              print('No documents found in the activityLogs collection');
            }
            for (var doc in snapshot.docs) {
              try {
                LogItem logItem = _createLogItem(doc);
                logs.add(logItem);
                print('Added log item: ${logItem.action}');
              } catch (e) {
                print('Error creating log item from document ${doc.id}: $e');
              }
            }
            _sortLogs();
            _filterLogs();
          }, onError: (error) {
            print('Error listening to activityLogs: $error');
          });
    } catch (e) {
      print('Error setting up listener for activityLogs: $e');
    }
  }

  LogItem _createLogItem(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      print('Error: Document data is null for ${doc.id}');
      return LogItem(
          date: DateTime.now(), action: 'Error formatting log entry');
    }

    String action = "";
    DateTime createdAt;

    try {
      createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    } catch (e) {
      print('Error parsing createdAt for document ${doc.id}: $e');
      createdAt = DateTime.now();
    }

    String formattedDate =
    DateFormat('EEE, d MMMM yyyy. HH:mm').format(createdAt);

    String formatItemName(String? itemName) {
      if (itemName == null) return 'Unknown Item';

      if (itemName.startsWith('merchandise.')) {
        switch (itemName) {
          case 'merchandise.poloShirt':
            return 'Merchandise Polo Shirt';
          case 'merchandise.tShirt':
            return 'Merchandise T-Shirt';
          case 'merchandise.luggageTag':
            return 'Merchandise Luggage Tag';
          case 'merchandise.jasHujan':
            return 'Merchandise Jas Hujan';
          default:
            return 'Merchandise';
        }
      } else if (itemName.startsWith('souvenir.')) {
        switch (itemName) {
          case 'souvenir.gelangTridatu':
            return 'Souvenir Gelang Tridatu';
          case 'souvenir.selendangUdeng':
            return 'Souvenir Selendang/Udeng';
          default:
            return 'Souvenir';
        }
      } else if (itemName.startsWith('benefit.')) {
        switch (itemName) {
          case 'benefit.voucherBelanja':
            return 'Benefit Tipe E-Wallet';
          case 'benefit.voucherEwallet':
            return 'Benefit Nomor E-Wallet';
          default:
            return 'Benefit';
        }
      } else {
        return itemName;
      }
    }

    try {
      switch (data['type']) {
        case 'participantkit_changed':
          String itemName = formatItemName(data['itemName']);
          String newStatus = data['newStatus'] ?? 'Unknown Status';
          String changedBy = data['changedBy'] ?? 'Unknown User';
          String participantName =
              data['participantName'] ?? 'Unknown Participant';

          action =
          '$formattedDate\n$changedBy updated $participantName Participant kit item $itemName status to $newStatus';
          break;

        case 'user_promotion':
          String newRole = data['newRole'] ?? 'Unknown Role';
          String changedBy = data['ChangedBy'] ?? 'Unknown User';
          String participantName =
              data['ParticipantName'] ?? 'Unknown Participant';

          action =
          '$formattedDate\n$participantName was promoted to $newRole by $changedBy';
          break;

        case 'report_reply':
          String reportTitle = data['reportTitle'] ?? 'Unknown Report';
          String reportName = data['reportName'] ?? 'Unknown Reporter';
          String repliedBy = data['repliedBy'] ?? 'Unknown User';

          action =
          '$formattedDate\nReport "$reportTitle" from $reportName was replied by $repliedBy';
          break;

        case 'participantkit_changed_all':
          String allItemName = formatItemName(data['itemName']);
          String newStatusAll = data['newstatusAll'] ?? 'unkown status';
          String changedBy = data['changedBy'] ?? 'Unknown User';
          String participantName =
              data['participantName'] ?? 'Unknown Participant';

          action =
          '$formattedDate\n$changedBy updated $participantName Participant kit $allItemName all item status to $newStatusAll';
          break;

        default:
          action = 'Unknown action type: ${data['type']}';
      }
    } catch (e) {
      print('Error formatting action for document ${doc.id}: $e');
      action = 'Error formatting log entry';
    }

    return LogItem(date: createdAt, action: action);
  }

  void _sortLogs() {
    logs.sort((a, b) => filter.value == 'newest'
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));
    _filterLogs();
  }

  void changeFilter(String? value) {
    if (value != null) {
      filter.value = value;
      _sortLogs();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _filterLogs();
  }

  void _filterLogs() {
    if (searchQuery.value.isEmpty) {
      filteredLogs.assignAll(logs);
    } else {
      filteredLogs.assignAll(logs.where((log) =>
          log.action.toLowerCase().contains(searchQuery.value.toLowerCase())));
    }
  }
}