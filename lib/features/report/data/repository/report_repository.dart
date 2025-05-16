import 'package:injectable/injectable.dart';

import '../../../transaction/model/transaction_model.dart';
import '../datasources/report_remote_datasource.dart';

@lazySingleton
class ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepository(this._remoteDataSource);

  Future<List<TransactionModel>> fetchTransactions({
    required Map<String, dynamic> filter,
  }) async {
    try {
      return await _remoteDataSource.fetchTransactions(filter: filter);
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
