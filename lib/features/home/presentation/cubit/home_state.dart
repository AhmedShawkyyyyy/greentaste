import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Recipe> recipes;

  const HomeSuccess(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}