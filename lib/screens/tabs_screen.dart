import 'package:flutter/material.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/filter_screen.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  final List<Meal> _favoriteMeal = [];

  void _toggleMealFavoritesStatus(Meal meal) {
    final isExisting = _favoriteMeal.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeal.remove(meal);
      });
      _showInfoMessage('Removed from Favorites');
    } else {
      setState(() {
        _favoriteMeal.add(meal);
      });
      _showInfoMessage('Added to Favorites');
    }
  }

  void _setScreen(String identifier) {
    if (identifier == 'Filters') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const FilterScreen()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoritesStatus,
    );
    var activeTitlePage = 'Your Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeal,
        onToggleFavorite: _toggleMealFavoritesStatus,
      );
      activeTitlePage = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTitlePage),
      ),
      drawer: MainDrawer(onSelectedScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            )
          ]),
    );
  }
}
