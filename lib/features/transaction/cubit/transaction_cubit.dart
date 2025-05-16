import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/transaction_repository.dart';
import '../model/transaction_model.dart';

part 'transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  int _currentOffset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final List<TransactionModel> _transactions = [];

  TransactionCubit(this._repository) : super(TransactionInitial());

  Future<void> fetchInitialTransactionsWithLimit(int limit) async {
    try {
      emit(TransactionLoading());
      _currentOffset = 0;
      _hasMore = true;
      _transactions.clear();

      final newTxs = await _repository.fetchTransactions(limit: limit, offset: _currentOffset);
      _transactions.addAll(newTxs);

      _currentOffset += newTxs.length;
      _hasMore = newTxs.length == limit;

      emit(TransactionLoaded(List.unmodifiable(_transactions), hasMore: _hasMore));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> fetchMoreTransactions(int limit) async {
    if (!_hasMore || _isLoadingMore) return;

    try {
      _isLoadingMore = true;

      final newTxs = await _repository.fetchTransactions(limit: limit, offset: _currentOffset);
      _transactions.addAll(newTxs);

      _currentOffset += newTxs.length;
      _hasMore = newTxs.length == limit;

      emit(TransactionLoaded(List.unmodifiable(_transactions), hasMore: _hasMore));
    } catch (e) {
      emit(TransactionError(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> addTransaction({
    required String categoryId,
    required double amount,
    String? note,
    DateTime? date,
  }) async {
    emit(TransactionLoading());
    try {
      final newTransaction = await _repository.createTransaction(
        categoryId: categoryId,
        amount: amount,
        note: note,
        date: date,
      );
      _transactions.insert(0, newTransaction);
      emit(TransactionLoaded(List.unmodifiable(_transactions), hasMore: _hasMore));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    double? amount,
    String? note,
    DateTime? date,
  }) async {
    emit(TransactionLoading());
    try {
      final updatedTransaction = await _repository.updateTransaction(
        id: id,
        categoryId: categoryId,
        amount: amount,
        note: note,
        date: date,
      );
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
      }
      emit(TransactionLoaded(List.unmodifiable(_transactions), hasMore: _hasMore));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> deleteTransaction(String id) async {
    emit(TransactionLoading());
    try {
      await _repository.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      emit(TransactionDeleted());
      emit(TransactionLoaded(List.unmodifiable(_transactions), hasMore: _hasMore));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
