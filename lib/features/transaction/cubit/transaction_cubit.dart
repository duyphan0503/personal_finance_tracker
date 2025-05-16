import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/transaction_repository.dart';
import '../model/transaction_model.dart';

part 'transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(TransactionInitial());

  Future<void> fetchAllTransactions() async {
    emit(TransactionLoading());
    try {
      final transactions = await _repository.fetchTransactions();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
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
      final currentState = state;
      if (currentState is TransactionLoaded) {
        final updatedList = List<TransactionModel>.from(currentState.transactions)
          ..add(newTransaction);
        _sortAndEmit(updatedList);
      } else {
        await fetchAllTransactions();
      }
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
      final currentState = state;
      if (currentState is TransactionLoaded) {
        final index = currentState.transactions.indexWhere((t) => t.id == id);
        if (index != -1) {
          final updatedList = List<TransactionModel>.from(currentState.transactions);
          updatedList[index] = updatedTransaction;
          _sortAndEmit(updatedList);
        } else {
          await fetchAllTransactions();
        }
      } else {
        await fetchAllTransactions();
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> deleteTransaction(String id) async {
    emit(TransactionLoading());
    try {
      await _repository.deleteTransaction(id);
      final currentState = state;
      if (currentState is TransactionLoaded) {
        final updatedList = currentState.transactions.where((t) => t.id != id).toList();
        emit(TransactionDeleted());
        emit(TransactionLoaded(updatedList));
      } else {
        emit(TransactionDeleted());
        await fetchAllTransactions();
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  void _sortAndEmit(List<TransactionModel> transactions) {
    transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    emit(TransactionLoaded(transactions));
  }
}
