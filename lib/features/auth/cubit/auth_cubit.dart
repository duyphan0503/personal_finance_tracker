import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_model.dart';

class AuthCubit extends Cubit<UserModel?> {
  AuthCubit() : super(null);

  void login(String email, String password) {
    // giả lập đăng nhập
    emit(UserModel(name: "Test User", email: email));
  }

  void logout() {
    emit(null);
  }
}