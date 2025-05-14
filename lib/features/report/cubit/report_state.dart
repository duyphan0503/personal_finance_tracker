part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCategoryLoaded extends ReportState {
  final List<CategoryReportItem> categoryData;

  const ReportCategoryLoaded({required this.categoryData});

  @override
  List<Object?> get props => [categoryData];
}

class ReportMonthlyLoaded extends ReportState {
  final List<MonthlyReportItem> monthlyData;

  const ReportMonthlyLoaded({required this.monthlyData});

  @override
  List<Object?> get props => [monthlyData];
}

class ReportSummaryLoaded extends ReportState {
  final SummaryReportData summaryData;

  const ReportSummaryLoaded({required this.summaryData});

  @override
  List<Object?> get props => [summaryData];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryReportItem extends Equatable {
  final String title;
  final double total;
  final List<CategoryReportPieItem> items;

  const CategoryReportItem({
    required this.title,
    required this.total,
    required this.items,
  });

  @override
  List<Object?> get props => [title, total, items];
}

class CategoryReportPieItem extends Equatable {
  final String name;
  final double value;
  final double percent;
  final String type;

  const CategoryReportPieItem({
    required this.name,
    required this.value,
    required this.percent,
    required this.type,
  });

  @override
  List<Object?> get props => [name, value, percent, type];
}

class MonthlyReportItem extends Equatable {
  final String monthLabel;
  final double income;
  final double expense;

  const MonthlyReportItem({
    required this.monthLabel,
    required this.income,
    required this.expense,
  });

  @override
  List<Object?> get props => [monthLabel, income, expense];
}

class SummaryReportData extends Equatable {
  final double balance;
  final double income;
  final double expense;

  const SummaryReportData({
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  List<Object?> get props => [balance, income, expense];
}
