import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.image,
    required super.readyInMinutes,
    required super.servings,
    super.summary,
    super.instructions,
    super.ingredients,
    super.nutrition,
    super.isFavorite,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'].toString(),
      title: json['name'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['prepTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      summary: json['tags']?.join(', '),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.join('\n'),
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      nutrition: NutritionModel(
        calories: (json['caloriesPerServing'] ?? 0).toDouble(),
        carbs: 0.0,
        protein: 0.0,
        fat: 0.0,
      ),
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'image': image,
      'prepTimeMinutes': readyInMinutes,
      'servings': servings,
      'instructions': instructions,
      'ingredients': ingredients,
      'caloriesPerServing': nutrition?.calories,
    };
  }
}

class NutritionModel extends Nutrition {
  const NutritionModel({
    required super.calories,
    required super.carbs,
    required super.protein,
    required super.fat,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      calories: (json['caloriesPerServing'] ?? 0).toDouble(),
      carbs: 0.0,
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caloriesPerServing': calories,
      'protein': protein,
      'fat': fat,
    };
  }
}