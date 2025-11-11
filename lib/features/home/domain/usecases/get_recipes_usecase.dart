import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<Either<Failure, List<Recipe>>> call() async {
    return await repository.getRecipes();
  }
}

class SearchRecipesUseCase {
  final RecipeRepository repository;

  SearchRecipesUseCase(this.repository);

  Future<Either<Failure, List<Recipe>>> call(String query) async {
    return await repository.searchRecipes(query);
  }
}

class GetRecipeDetailsUseCase {
  final RecipeRepository repository;

  GetRecipeDetailsUseCase(this.repository);

  Future<Either<Failure, Recipe>> call(String id) async {
    return await repository.getRecipeDetails(id);
  }
}

class GetRecipesByCategoryUseCase {
  final RecipeRepository repository;

  GetRecipesByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Recipe>>> call(String category) async {
    return await repository.getRecipesByCategory(category);
  }
}