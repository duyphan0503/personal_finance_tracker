import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';

@lazySingleton
class ReportSummaryRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReportSummaryRemoteDataSource(
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  )   : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<TransactionModel>> getTransactionsForMonth(DateTime month) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('transactions')
          .where('user_id', isEqualTo: user.uid)
          .where('transaction_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('transaction_date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('transaction_date', descending: true)
          .get();

      List<TransactionModel> transactions = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        
        // Fetch category data
        DocumentSnapshot? categoryDoc;
        if (data['category_id'] != null) {
          categoryDoc = await _firestore
              .collection('categories')
              .doc(data['category_id'])
              .get();
        }

        final transactionData = {
          'id': doc.id,
          ...data,
          if (categoryDoc != null && categoryDoc.exists)
            'categories': {
              'id': categoryDoc.id,
              ...categoryDoc.data() as Map<String, dynamic>,
            },
        };

        transactions.add(TransactionModel.fromJson(transactionData));
      }

      return transactions;
    } catch (e) {
      throw Exception('Failed to fetch monthly transactions: $e');
    }
  }
}