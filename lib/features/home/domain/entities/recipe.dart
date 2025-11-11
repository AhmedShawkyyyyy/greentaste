import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String? summary;
  final String? instructions;
  final List<String>? ingredients;
  final Nutrition? nutrition;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    this.summary,
    this.instructions,
    this.ingredients,
    this.nutrition,
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? image,
    int? readyInMinutes,
    int? servings,
    String? summary,
    String? instructions,
    List<String>? ingredients,
    Nutrition? nutrition,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      readyInMinutes: readyInMinutes ?? this.readyInMinutes,
      servings: servings ?? this.servings,
      summary: summary ?? this.summary,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      nutrition: nutrition ?? this.nutrition,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    readyInMinutes,
    servings,
    summary,
    instructions,
    ingredients,
    nutrition,
    isFavorite,
  ];
}

class Nutrition extends Equatable {
  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  const Nutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  @override
  List<Object?> get props => [calories, carbs, protein, fat];
}