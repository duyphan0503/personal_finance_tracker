import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../transaction/model/transaction_model.dart';

@lazySingleton
class ReportRemoteDataSource {
  final SupabaseClient _client;

  ReportRemoteDataSource(SupabaseClient? client)
    : _client = client ?? Supabase.instance.client;

  Future<List<TransactionModel>> fetchTransactions({
    required Map<String, dynamic> filter,
  }) async {
    try {
      final int? month = filter['month'];
      final int? year = filter['year'];
      final String? categoryId = filter['categoryId'];

      var query = _client
          .from('transactions')
          .select('*, categories(*)')
          .eq('user_id', '${_client.auth.currentUser?.id}');

      if (month != null && year != null) {
        final startDate = DateTime(year, month, 1);
        final endDate = DateTime(year, month + 1, 0);
        query = query
            .gte('transaction_date', startDate.toIso8601String())
            .lte('transaction_date', endDate.toIso8601String());
      }

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final res = await query.order('transaction_date', ascending: false);

      return (res as List)
          .map((data) => TransactionModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions for report: $e');
    }
  }
}
