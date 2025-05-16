import 'package:injectable/injectable.dart';

import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart';

import '../datasources/report_summary_remote_datasource.dart';

@lazySingleton
class ReportSummaryRepository {
  final ReportSummaryRemoteDataSource _remoteDataSource;

  ReportSummaryRepository(this._remoteDataSource);

  Future<List<TransactionModel>> getMonthlyTransactions(DateTime month) async {
    try {
      return await _remoteDataSource.getTransactionsForMonth(month);
    } catch (e) {
      throw Exception('Failed to get monthly transactions: $e');
    }
  }
}