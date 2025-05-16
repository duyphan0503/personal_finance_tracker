part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final bool hasMore;

  TransactionLoaded(this.transactions, {this.hasMore = false});

  @override
  List<Object?> get props => [transactions, hasMore];
}

class TransactionDeleted extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
