import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../home/domain/entities/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool _isFavorite = false;
  bool _showIngredients = true;

  @override
  void initState() {
    super.initState();
    _isFavorite = SharedPrefsHelper.isFavorite(widget.recipe.id);
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      SharedPrefsHelper.addToFavorites(widget.recipe.id);
    } else {
      SharedPrefsHelper.removeFromFavorites(widget.recipe.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildNutritionInfo(),
                _buildTabBar(),
                _showIngredients
                    ? _buildIngredients()
                    : _buildInstructions(),
                _buildCreator(),
                _buildRelatedRecipes(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
          ),
          onPressed: _toggleFavorite,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.recipe.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.recipe.summary ?? '',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text(AppStrings.viewMore),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    if (widget.recipe.nutrition == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(
            Icons.local_fire_department,
            '${widget.recipe.nutrition!.calories.toInt()}',
            AppStrings.kcal,
          ),
          _buildNutritionItem(
            Icons.restaurant,
            '${widget.recipe.nutrition!.carbs.toInt()}g',
            AppStrings.carbs,
          ),
          _buildNutritionItem(
            Icons.fitness_center,
            '${widget.recipe.nutrition!.protein.toInt()}g',
            AppStrings.proteins,
          ),
          _buildNutritionItem(
            Icons.water_drop,
            '${widget.recipe.nutrition!.fat.toInt()}g',
            AppStrings.fats,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showIngredients = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _showIngredients
                    ? AppColors.primary
                    : Colors.grey[200],
                foregroundColor:
                _showIngredients ? Colors.white : Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(AppStrings.ingredients),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showIngredients = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !_showIngredients
                    ? AppColors.primary
                    : Colors.grey[200],
                foregroundColor:
                !_showIngredients ? Colors.white : Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(AppStrings.instructions),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    final ingredients = widget.recipe.ingredients ??
        [
          'Tortilla Chips',
          'Avocado',
          'Red Cabbage',
          'Peanuts',
          'Red Onions',
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.ingredients,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.addAllToCart),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...ingredients.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fastfood,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {},
                      ),
                      const Text('1'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        widget.recipe.instructions ??
            'Instructions will be displayed here...',
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCreator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.creator,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Natalie Luca',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "I'm the author and recipe developer.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedRecipes() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.relatedRecipes,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.seeAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.recipe.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          AppStrings.addToCart,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}