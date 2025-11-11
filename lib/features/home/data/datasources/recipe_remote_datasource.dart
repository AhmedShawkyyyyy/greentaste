import '../../../../core/utils/dio_helper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<RecipeModel> getRecipeDetails(String id);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  @override
  Future<List<RecipeModel>> getRecipes() async {
    final response = await DioHelper.getData(
      url: '/recipes',
      query: {
        'limit': 20,
      },
    );

    final List<dynamic> recipesData = response.data['recipes'];
    return recipesData.map((json) => RecipeModel.fromJson(json)).toList();
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    final response = await DioHelper.getData(
      url: '/recipes/search',
      query: {
        'q': query,
      },
    );

    final List<dynamic> recipesData = response.data['recipes'];
    return recipesData.map((json) => RecipeModel.fromJson(json)).toList();
  }

  @override
  Future<RecipeModel> getRecipeDetails(String id) async {
    final response = await DioHelper.getData(
      url: '/recipes/$id',
    );

    return RecipeModel.fromJson(response.data);
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    final response = await DioHelper.getData(
      url: '/recipes/tag/$category',
    );

    final List<dynamic> recipesData = response.data['recipes'];
    return recipesData.map((json) => RecipeModel.fromJson(json)).toList();
  }
}