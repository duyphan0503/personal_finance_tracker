// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:personal_finance_tracker/features/auth/cubit/auth_cubit.dart'
    as _i909;
import 'package:personal_finance_tracker/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i387;
import 'package:personal_finance_tracker/features/auth/data/repositories/auth_repository.dart'
    as _i441;
import 'package:personal_finance_tracker/features/budget/cubit/budget_cubit.dart'
    as _i540;
import 'package:personal_finance_tracker/features/budget/data/datasources/budget_remote_datasource.dart'
    as _i417;
import 'package:personal_finance_tracker/features/budget/data/repository/budget_repository.dart'
    as _i480;
import 'package:personal_finance_tracker/features/budget/model/budget_model.dart'
    as _i755;
import 'package:personal_finance_tracker/features/category/cubit/category_cubit.dart'
    as _i688;
import 'package:personal_finance_tracker/features/category/data/datasources/category_remote_datasource.dart'
    as _i589;
import 'package:personal_finance_tracker/features/category/data/repository/category_repository.dart'
    as _i125;
import 'package:personal_finance_tracker/features/category/model/category_model.dart'
    as _i800;
import 'package:personal_finance_tracker/features/dashboard/cubit/dashboard_cubit.dart'
    as _i988;
import 'package:personal_finance_tracker/features/report/cubit/report_cubit.dart'
    as _i741;
import 'package:personal_finance_tracker/features/report/data/datasources/report_remote_datasource.dart'
    as _i330;
import 'package:personal_finance_tracker/features/report/data/repository/report_repository.dart'
    as _i1070;
import 'package:personal_finance_tracker/features/report/summary/cubit/report_summary_cubit.dart'
    as _i39;
import 'package:personal_finance_tracker/features/report/summary/data/datasources/report_summary_remote_datasource.dart'
    as _i993;
import 'package:personal_finance_tracker/features/report/summary/data/repository/report_summary_repository.dart'
    as _i621;
import 'package:personal_finance_tracker/features/transaction/cubit/transaction_cubit.dart'
    as _i716;
import 'package:personal_finance_tracker/features/transaction/data/datasources/transaction_remote_datasource.dart'
    as _i114;
import 'package:personal_finance_tracker/features/transaction/data/repository/transaction_repository.dart'
    as _i1067;
import 'package:personal_finance_tracker/features/transaction/model/transaction_model.dart'
    as _i854;
import 'package:personal_finance_tracker/register_firebase_module.dart'
    as _i906;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerFirebaseModule = _$RegisterFirebaseModule();
    
    // Register Firebase services
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => registerFirebaseModule.firebaseAuth,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerFirebaseModule.firebaseFirestore,
    );
    
    // Register models
    gh.factory<_i800.CategoryModel>(
      () => _i800.CategoryModel(
        id: gh<String>(),
        name: gh<String>(),
        type: gh<_i800.CategoryType>(),
      ),
    );
    gh.factory<_i755.BudgetModel>(
      () => _i755.BudgetModel(
        id: gh<String>(),
        categoryId: gh<String>(),
        amount: gh<double>(),
        category: gh<_i800.CategoryModel>(),
      ),
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
    
    // Register data sources
    gh.lazySingleton<_i589.CategoryRemoteDataSource>(
      () => _i589.CategoryRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i330.ReportRemoteDataSource>(
      () => _i330.ReportRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i114.TransactionRemoteDataSource>(
      () => _i114.TransactionRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i993.ReportSummaryRemoteDataSource>(
      () => _i993.ReportSummaryRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i417.BudgetRemoteDataSource>(
      () => _i417.BudgetRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i589.CategoryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i387.AuthRemoteDataSource>(
      () => _i387.AuthRemoteDataSource(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    
    // Register repositories
    gh.lazySingleton<_i125.CategoryRepository>(
      () => _i125.CategoryRepository(gh<_i589.CategoryRemoteDataSource>()),
    );
    gh.lazySingleton<_i1067.TransactionRepository>(
      () => _i1067.TransactionRepository(gh<_i114.TransactionRemoteDataSource>()),
    );
    gh.lazySingleton<_i621.ReportSummaryRepository>(
      () => _i621.ReportSummaryRepository(
        gh<_i993.ReportSummaryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1070.ReportRepository>(
      () => _i1070.ReportRepository(gh<_i330.ReportRemoteDataSource>()),
    );
    gh.lazySingleton<_i441.AuthRepository>(
      () => _i441.AuthRepository(dataSource: gh<_i387.AuthRemoteDataSource>()),
    );
    gh.factory<_i480.BudgetRepository>(
      () => _i480.BudgetRepository(
        gh<_i417.BudgetRemoteDataSource>(),
        gh<_i589.CategoryRemoteDataSource>(),
      ),
    );
    
    // Register cubits
    gh.factory<_i988.DashboardCubit>(
      () => _i988.DashboardCubit(gh<_i1067.TransactionRepository>()),
    );
    gh.factory<_i688.CategoryCubit>(
      () => _i688.CategoryCubit(gh<_i125.CategoryRepository>()),
    );
    gh.factory<_i39.ReportSummaryCubit>(
      () => _i39.ReportSummaryCubit(gh<_i621.ReportSummaryRepository>()),
    );
    gh.factory<_i741.ReportCubit>(
      () => _i741.ReportCubit(gh<_i1070.ReportRepository>()),
    );
    gh.factory<_i540.BudgetCubit>(
      () => _i540.BudgetCubit(gh<_i480.BudgetRepository>()),
    );
    gh.factory<_i909.AuthCubit>(
      () => _i909.AuthCubit(authRepository: gh<_i441.AuthRepository>()),
    );
    gh.factory<_i716.TransactionCubit>(
      () => _i716.TransactionCubit(
        gh<_i1067.TransactionRepository>(),
        gh<_i480.BudgetRepository>(),
      ),
    );
    
    return this;
  }
}

class _$RegisterFirebaseModule extends _i906.RegisterFirebaseModule {}
