import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../recipe_details/presentation/screens/recipe_details_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getRecipes(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.goodMorning,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              SharedPrefsHelper.getUserName() ?? 'Alena Sabyan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(child: Text(state.message));
          }

          if (state is HomeSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeaturedSection(context, state),
                  _buildCategorySection(context),
                  _buildPopularRecipes(context, state),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, HomeSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppStrings.featured,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.recipes.take(5).length,
            itemBuilder: (context, index) {
              final recipe = state.recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailsScreen(recipe: recipe),
                    ),
                  );
                },
                child: Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(recipe.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe.readyInMinutes} min',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppStrings.category,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(AppStrings.breakfast),
              _buildCategoryChip(AppStrings.lunch),
              _buildCategoryChip(AppStrings.dinner),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
          context.read<HomeCubit>().filterByCategory(category);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPopularRecipes(BuildContext context, HomeSuccess state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.popularRecipes,
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
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.recipes.take(6).length,
          itemBuilder: (context, index) {
            final recipe = state.recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailsScreen(recipe: recipe),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          recipe.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.readyInMinutes} min',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
            break;
          case 2:
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.iconInactive,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}