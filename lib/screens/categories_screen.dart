import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

// here we created _selectedCategory method to connet CategoriesScreen and MealsScreen
  void _selectedCategory(BuildContext context) {
    // here we are writing BuildContext context inside function because in stateless widgets context is not available globally
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(meals: [], title: 'some titile'),
      ),
    ); // Navigator.push(context,route)  both are same , here route is created using MaterialPageRoute class.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Category'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          // availableCategories.map((category) => CategoryGridItem(category: category))
          for (final category in availableCategories)
            CategoryGridItem(
                category: category,
                onSelectedCategory: () {
                  _selectedCategory(context);
                })
        ],
      ),
    );
  }
}
