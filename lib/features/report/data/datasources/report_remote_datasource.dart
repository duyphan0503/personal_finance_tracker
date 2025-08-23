import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../transaction/model/transaction_model.dart';

@lazySingleton
class ReportRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReportRemoteDataSource(
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  )   : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<TransactionModel>> fetchTransactions({
    required Map<String, dynamic> filter,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final int? month = filter['month'];
      final int? year = filter['year'];
      final String? categoryId = filter['categoryId'];

      Query query = _firestore
          .collection('transactions')
          .where('user_id', isEqualTo: user.uid);

      if (month != null && year != null) {
        final startDate = DateTime(year, month, 1);
        final endDate = DateTime(year, month + 1, 0);
        query = query
            .where('transaction_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('transaction_date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      if (categoryId != null) {
        query = query.where('category_id', isEqualTo: categoryId);
      }

      final querySnapshot = await query
          .orderBy('transaction_date', descending: true)
          .get();

      List<TransactionModel> transactions = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
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
      throw Exception('Failed to fetch transactions for report: $e');
    }
  }
}
