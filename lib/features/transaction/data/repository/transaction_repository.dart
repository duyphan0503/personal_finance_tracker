import 'package:injectable/injectable.dart';

import '../../model/transaction_model.dart';
import '../datasources/transaction_remote_datasource.dart';

@lazySingleton
class TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepository(this.remoteDataSource);

  Future<List<TransactionModel>> fetchTransactions({
    int limit = 10,
    int offset = 0,
  }) => remoteDataSource.fetchTransactions(limit: limit, offset: offset);


  Future<TransactionModel> createTransaction({
    required String categoryId,
    required double amount,
    String? note,
    DateTime? date,
  }) => remoteDataSource.createTransaction(
    categoryId: categoryId,
    amount: amount,
    note: note,
    date: date,
  );

  Future<TransactionModel> updateTransaction({
    required String id,
    String? categoryId,
    double? amount,
    String? note,
    DateTime? date,
  }) => remoteDataSource.updateTransaction(
    id: id,
    categoryId: categoryId,
    amount: amount,
    note: note,
    date: date,
  );

  Future<void> deleteTransaction(String id) =>
      remoteDataSource.deleteTransaction(id);
}
