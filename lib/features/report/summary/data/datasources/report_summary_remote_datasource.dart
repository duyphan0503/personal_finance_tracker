import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';

@lazySingleton
class ReportSummaryRemoteDataSource {
  final SupabaseClient _client;

  ReportSummaryRemoteDataSource(SupabaseClient? client)
      : _client = client ?? Supabase.instance.client;
  Future<List<TransactionModel>> getTransactionsForMonth(DateTime month) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final data = await _client
          .from('transactions')
          .select('*, categories(*)') // Đảm bảo bảng liên kết đúng
          .gte('transaction_date', startDate.toIso8601String())
          .lte('transaction_date', endDate.toIso8601String())
          .order('transaction_date', ascending: false);

      return (data as List<dynamic>)
          .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch monthly transactions: $e');
    }
  }


}