import '../../../../core/utils/dio_helper.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await DioHelper.postData(
        url: '/auth/login',
        data: {
          'username': 'emilys',
          'password': 'emilyspass',
        },
      );

      final user = UserModel(
        id: response.data['id'].toString(),
        name: response.data['firstName'] ?? 'User',
        email: response.data['email'] ?? email,
        token: response.data['token'],
      );

      await SharedPrefsHelper.saveToken(user.token ?? '');
      await SharedPrefsHelper.saveUserName(user.name);
      await SharedPrefsHelper.saveUserEmail(user.email);
      await SharedPrefsHelper.setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(
      String name, String email, String password) async {
    try {
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      await SharedPrefsHelper.saveToken(user.token ?? '');
      await SharedPrefsHelper.saveUserName(user.name);
      await SharedPrefsHelper.saveUserEmail(user.email);
      await SharedPrefsHelper.setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await SharedPrefsHelper.logout();
  }
}