// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:personal_finance_tracker/features/budget/model/category_model.dart'
    as _i824;
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart'
    as _i716;
import 'package:personal_finance_tracker/features/transaction/data/datasources/transaction_remote_datasource.dart'
    as _i114;
import 'package:personal_finance_tracker/features/transaction/data/repository/transaction_repository.dart'
    as _i1067;
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart'
    as _i854;
import 'package:personal_finance_tracker/register_supabase_module.dart'
    as _i906;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerSupabaseModule = _$RegisterSupabaseModule();
    gh.lazySingleton<_i454.SupabaseClient>(
      () => registerSupabaseModule.supabaseClient,
    );
    gh.lazySingleton<_i114.TransactionRemoteDataSource>(
      () => _i114.TransactionRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1067.TransactionRepository>(
      () =>
          _i1067.TransactionRepository(gh<_i114.TransactionRemoteDataSource>()),
    );
    gh.factory<_i854.TransactionModel>(
      () => _i854.TransactionModel(
        id: gh<String>(),
        userId: gh<String>(),
        amount: gh<double>(),
        transactionDate: gh<DateTime>(),
        note: gh<String>(),
        categoryId: gh<String>(),
        category: gh<_i824.CategoryModel>(),
        createdAt: gh<DateTime>(),
      ),
    );
    gh.factory<_i716.TransactionCubit>(
      () => _i716.TransactionCubit(gh<_i1067.TransactionRepository>()),
    );
    return this;
  }
}

class _$RegisterSupabaseModule extends _i906.RegisterSupabaseModule {}
