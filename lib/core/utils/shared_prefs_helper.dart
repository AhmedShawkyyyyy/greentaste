import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  static Set<String> getKeys() {
    return _prefs.getKeys();
  }

  static Future<bool> saveToken(String token) async {
    return await setString('token', token);
  }

  static String? getToken() {
    return getString('token');
  }

  static Future<bool> setLoggedIn(bool value) async {
    return await setBool('isLoggedIn', value);
  }

  static bool isLoggedIn() {
    return getBool('isLoggedIn') ?? false;
  }

  static Future<bool> setDarkMode(bool isDark) async {
    return await setBool('isDarkMode', isDark);
  }

  static bool isDarkMode() {
    return getBool('isDarkMode') ?? false;
  }

  static Future<bool> saveUserName(String name) async {
    return await setString('userName', name);
  }

  static String? getUserName() {
    return getString('userName');
  }

  static Future<bool> saveUserEmail(String email) async {
    return await setString('userEmail', email);
  }

  static String? getUserEmail() {
    return getString('userEmail');
  }

  static Future<bool> saveFavorites(List<String> favorites) async {
    return await setStringList('favorites', favorites);
  }

  static List<String> getFavorites() {
    return getStringList('favorites') ?? [];
  }

  static Future<bool> addToFavorites(String recipeId) async {
    List<String> favorites = getFavorites();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      return await saveFavorites(favorites);
    }
    return true;
  }

  static Future<bool> removeFromFavorites(String recipeId) async {
    List<String> favorites = getFavorites();
    favorites.remove(recipeId);
    return await saveFavorites(favorites);
  }

  static bool isFavorite(String recipeId) {
    return getFavorites().contains(recipeId);
  }

  static Future<bool> logout() async {
    await remove('token');
    await remove('userName');
    await remove('userEmail');
    await setLoggedIn(false);
    return true;
  }
}