import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<Recipe>>> getRecipes();
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query);
  Future<Either<Failure, Recipe>> getRecipeDetails(String id);
  Future<Either<Failure, List<Recipe>>> getRecipesByCategory(String category);
}