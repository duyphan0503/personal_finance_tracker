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
import 'package:personal_finance_tracker/features/auth/cubit/auth_cubit.dart'
    as _i909;
import 'package:personal_finance_tracker/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i387;
import 'package:personal_finance_tracker/features/auth/data/repositories/auth_repository.dart'
    as _i441;
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart'
    as _i688;
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart'
    as _i589;
import 'package:personal_finance_tracker/features/category/data/repository/category_repository.dart'
    as _i125;
import 'package:personal_finance_tracker/features/category/model/category_model.dart'
    as _i800;
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
    gh.lazySingleton<_i589.CategoryRemoteDataSource>(
      () => _i589.CategoryRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i114.TransactionRemoteDataSource>(
      () => _i114.TransactionRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i125.CategoryRepository>(
      () => _i125.CategoryRepository(gh<_i589.CategoryRemoteDataSource>()),
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
        category: gh<_i800.CategoryModel>(),
        createdAt: gh<DateTime>(),
      ),
    );
    gh.lazySingleton<_i387.AuthRemoteDataSource>(
      () => _i387.AuthRemoteDataSource(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i716.TransactionCubit>(
      () => _i716.TransactionCubit(gh<_i1067.TransactionRepository>()),
    );
    gh.factory<_i688.CategoryCubit>(
      () => _i688.CategoryCubit(gh<_i125.CategoryRepository>()),
    );
    gh.lazySingleton<_i441.AuthRepository>(
      () => _i441.AuthRepository(dataSource: gh<_i387.AuthRemoteDataSource>()),
    );
    gh.factory<_i909.AuthCubit>(
      () => _i909.AuthCubit(authRepository: gh<_i441.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterSupabaseModule extends _i906.RegisterSupabaseModule {}
