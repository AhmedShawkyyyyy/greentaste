import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes() async {
    try {
      final recipes = await remoteDataSource.getRecipes();
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query) async {
    try {
      final recipes = await remoteDataSource.searchRecipes(query);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeDetails(String id) async {
    try {
      final recipe = await remoteDataSource.getRecipeDetails(id);
      return Right(recipe);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByCategory(
      String category) async {
    try {
      final recipes = await remoteDataSource.getRecipesByCategory(category);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}