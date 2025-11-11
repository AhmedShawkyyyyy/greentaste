import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../../../../core/utils/dio_helper.dart';
import '../../data/models/recipe_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<RecipeModel> allRecipes = [];
  List<RecipeModel> featuredRecipes = [];
  List<RecipeModel> breakfastRecipes = [];
  List<RecipeModel> lunchRecipes = [];
  List<RecipeModel> dinnerRecipes = [];

  Future<void> getRecipes() async {
    emit(HomeLoading());

    try {
      final response = await DioHelper.getData(
        url: '/recipes',
        query: {
          'limit': 30,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> recipesData = response.data['recipes'];
        allRecipes = recipesData
            .map((json) => RecipeModel.fromJson(json))
            .toList();

        featuredRecipes = allRecipes.take(5).toList();
        breakfastRecipes = allRecipes.skip(5).take(5).toList();
        lunchRecipes = allRecipes.skip(10).take(5).toList();
        dinnerRecipes = allRecipes.skip(15).take(5).toList();

        emit(HomeSuccess(allRecipes));
      } else {
        emit(const HomeError('Failed to load recipes'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      emit(HomeSuccess(allRecipes));
      return;
    }

    emit(HomeLoading());

    try {
      final response = await DioHelper.getData(
        url: '/recipes/search',
        query: {
          'q': query,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> recipesData = response.data['recipes'];
        final recipes = recipesData
            .map((json) => RecipeModel.fromJson(json))
            .toList();

        emit(HomeSuccess(recipes));
      } else {
        emit(const HomeError('Failed to search recipes'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void filterByCategory(String category) {
    List<RecipeModel> filtered;

    switch (category.toLowerCase()) {
      case 'breakfast':
        filtered = breakfastRecipes;
        break;
      case 'lunch':
        filtered = lunchRecipes;
        break;
      case 'dinner':
        filtered = dinnerRecipes;
        break;
      default:
        filtered = allRecipes;
    }

    emit(HomeSuccess(filtered));
  }
}