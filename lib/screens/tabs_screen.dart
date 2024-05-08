import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';// to use riverpod package
import 'package:meals/provider/favorites_provider.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/filter_screen.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/provider/meals_provider.dart';

const kInitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget { //addition of Consumer is due to riverpod package
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
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

  Map<Filter, bool> _selectedFilters = kInitialFilter;

  

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
    final meals = ref.watch(mealsProvider);// ref refers the provider from riverpod
  final availableMeals = meals.where((meal){
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
        CategoriesScreen(availableMeals: availableMeals);
    var activeTitlePage = 'Your Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
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
