import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/transaction_model.dart';

@lazySingleton
class TransactionRemoteDataSource {
  final SupabaseClient _client;

  TransactionRemoteDataSource(SupabaseClient? client)
      : _client = client ?? Supabase.instance.client;

  Future<List<TransactionModel>> fetchTransactions({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      await Supabase.instance.client.auth.refreshSession();
      final res = await _client
          .from('transactions')
          .select('*,categories(*)')
          .eq('user_id', "${_client.auth.currentUser?.id}")
          .order('transaction_date', ascending: false)
          .range(offset, offset + limit - 1);
      return res.map((data) => TransactionModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Các phương thức create/update/delete giữ nguyên
  Future<TransactionModel> createTransaction({
    required String categoryId,
    required double amount,
    String? note,
    DateTime? date,
  }) async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }

      if (session.isExpired) {
        await _client.auth.refreshSession();
      }

      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final payload = {
        'category_id': categoryId,
        'amount': amount,
        'note': note,
        'transaction_date': (date ?? DateTime.now()).toUtc().toIso8601String(),
        'user_id': currentUser.id,
      };
      final res =
      await _client
          .from('transactions')
          .insert(payload)
          .select('*,categories(*)')
          .single();
      return TransactionModel.fromJson(res);
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
      final Map<String, dynamic> changes = {};
      if (categoryId != null) changes['category_id'] = categoryId;
      if (amount != null) changes['amount'] = amount;
      if (note != null) changes['note'] = note;
      if (date != null) {
        changes['transaction_date'] = date.toUtc().toIso8601String();
      }
      final res =
      await _client
          .from('transactions')
          .update(changes)
          .eq('id', id)
          .eq('user_id', "${_client.auth.currentUser?.id}")
          .select('*,categories(*)')
          .single();
      return TransactionModel.fromJson(res);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _client.from('transactions').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
