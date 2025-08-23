import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/transaction_model.dart';

@lazySingleton
class TransactionRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TransactionRemoteDataSource(
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  )   : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<TransactionModel>> fetchTransactions({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('transactions')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('transaction_date', descending: true)
          .limit(limit)
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
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> createTransaction({
    required String categoryId,
    required double amount,
    String? note,
    DateTime? date,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final transactionDate = date ?? DateTime.now();
      final payload = {
        'category_id': categoryId,
        'amount': amount,
        'note': note,
        'transaction_date': Timestamp.fromDate(transactionDate),
        'user_id': user.uid,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection('transactions')
          .add(payload);

      // Fetch the created transaction with category data
      final doc = await docRef.get();
      final data = doc.data()!;
      
      // Fetch category data
      final categoryDoc = await _firestore
          .collection('categories')
          .doc(categoryId)
          .get();

      final transactionData = {
        'id': doc.id,
        ...data,
        if (categoryDoc.exists)
          'categories': {
            'id': categoryDoc.id,
            ...categoryDoc.data()!,
          },
      };

      return TransactionModel.fromJson(transactionData);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<TransactionModel> updateTransaction({
    required String id,
    String? categoryId,
    double? amount,
    String? note,
    DateTime? date,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final Map<String, dynamic> updates = {
        'updated_at': FieldValue.serverTimestamp(),
      };
      
      if (categoryId != null) updates['category_id'] = categoryId;
      if (amount != null) updates['amount'] = amount;
      if (note != null) updates['note'] = note;
      if (date != null) updates['transaction_date'] = Timestamp.fromDate(date);

      await _firestore
          .collection('transactions')
          .doc(id)
          .update(updates);

      // Fetch the updated transaction with category data
      final doc = await _firestore
          .collection('transactions')
          .doc(id)
          .get();
      
      final data = doc.data()!;
      
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

      return TransactionModel.fromJson(transactionData);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
