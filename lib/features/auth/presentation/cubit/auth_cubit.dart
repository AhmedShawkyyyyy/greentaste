import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../domain/entities/user.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      final savedEmail = SharedPrefsHelper.getString('registered_email');
      final savedPassword = SharedPrefsHelper.getString('registered_password');
      final savedName = SharedPrefsHelper.getString('registered_name');

      if (savedEmail == null || savedPassword == null) {
        emit(const AuthError('No account found. Please register first.'));
        return;
      }

      if (savedEmail == email && savedPassword == password) {
        final user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: savedName ?? 'User',
          email: email,
          token: 'token_${DateTime.now().millisecondsSinceEpoch}',
        );

        await SharedPrefsHelper.saveToken(user.token ?? '');
        await SharedPrefsHelper.saveUserName(user.name);
        await SharedPrefsHelper.saveUserEmail(user.email);
        await SharedPrefsHelper.setLoggedIn(true);

        emit(AuthSuccess(user));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      final existingEmail = SharedPrefsHelper.getString('registered_email');

      if (existingEmail == email) {
        emit(const AuthError('Email already registered. Please login.'));
        return;
      }

      await SharedPrefsHelper.setString('registered_name', name);
      await SharedPrefsHelper.setString('registered_email', email);
      await SharedPrefsHelper.setString('registered_password', password);

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        token: 'token_${DateTime.now().millisecondsSinceEpoch}',
      );

      await SharedPrefsHelper.saveToken(user.token ?? '');
      await SharedPrefsHelper.saveUserName(name);
      await SharedPrefsHelper.saveUserEmail(email);
      await SharedPrefsHelper.setLoggedIn(true);

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await SharedPrefsHelper.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}