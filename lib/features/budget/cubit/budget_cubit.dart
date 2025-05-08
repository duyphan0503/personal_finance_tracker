import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'budget_state.dart';

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(BudgetInitial());
}
