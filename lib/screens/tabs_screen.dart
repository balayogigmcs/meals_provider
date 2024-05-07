import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/filter_screen.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

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
  Map<Filter, bool> _selectedFilters = kInitialFilter;

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'Filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) =>  FilterScreen(currentFilters: _selectedFilters)),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilter;
      });
// ?? indicates fallback value when result is null
    }
  }

  @override
  Widget build(BuildContext context) {
  final availableMeals = dummyMeals.where((meal){
    if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
      return false;
    }
    if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
      return false;
    }
    if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
      return false;
    }
    if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
      return false;
    }
    return true;
  }).toList();

    Widget activePage =
        CategoriesScreen(onToggleFavorite: _toggleMealFavoritesStatus,availableMeals: availableMeals);
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
