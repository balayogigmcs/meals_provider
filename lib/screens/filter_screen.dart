import 'package:flutter/material.dart';
import 'package:meals/screens/tabs_screen.dart';
import 'package:meals/widgets/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() {
    return _FilterScreenState();
  }
}

var _glutenFreeFilterSet = false;

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      drawer: MainDrawer(onSelectedScreen: (identifier) {
        Navigator.of(context).pop();
        if (identifier == 'Meals') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => TabsScreen()));
        }
      }),
      body: Column(
        children: [
          SwitchListTile(
            value: _glutenFreeFilterSet,
            onChanged: (isCheckedout) {
              setState(() {
                _glutenFreeFilterSet = isCheckedout;
              });
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              'Only Included Gluten-free Meals',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          )
        ],
      ),
    );
  }
}
