class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  static const String apiKey = '';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String recipes = '/recipes';
  static const String recipeDetails = '/recipes/{id}';
  static const String searchRecipes = '/recipes/search';

  static Map<String, dynamic> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}