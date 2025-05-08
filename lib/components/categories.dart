import 'package:flutter/material.dart';
import './custom_item.dart';
import './custom_icon_button.dart';
import '../theme.dart'; // Importez le fichier TabItem si nécessaire

class Categories extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback function
  final bool isTitle;
  const Categories({
    Key? key,
    required this.onCategorySelected,
    this.isTitle = true,
  }):super(key:key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selectedIndex = 0;

  void _onTabSelected(int index, String category) {
    print('Tab changed to $index' + category);
    setState(() {
      _selectedIndex = index;
    });
    widget.onCategorySelected(category); // Call the callback with the selected category
  }

  bool isActive(int id) {
    return id == _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all((widget.isTitle)?12:0),
      child: Column(children: [
        if(widget.isTitle) Row(
          children: [
            Text(
              'Catégories',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.33,
                decoration: TextDecoration.none,
                color: MaterialTheme.lightScheme().primary,
              ),
            ),
            Spacer(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Permet le défilement horizontal
            child: Row(
              children: [
                CustomItem(
                  label: "Tout",
                  onPressed: () => _onTabSelected(0, "Tout"),
                  active: isActive(0),
                  icon: Icons.all_inclusive_outlined,
                  activeIcon: Icons.all_inclusive_rounded,
                ),
                CustomItem(
                  label: "Pizza",
                  onPressed: () => _onTabSelected(1, "Pizza"),
                  active: isActive(1),
                  icon: Icons.local_pizza_outlined,
                  activeIcon: Icons.local_pizza_rounded,
                ),
                CustomItem(
                  label: "Burger",
                  onPressed: () => _onTabSelected(2, "Burger"),
                  active: isActive(2),
                  icon: Icons.lunch_dining_outlined,
                  activeIcon: Icons.lunch_dining_rounded,
                ),
                CustomItem(
                  label: "Glaces",
                  onPressed: () => _onTabSelected(3, "Glaces"),
                  active: isActive(3),
                  icon: Icons.icecream_outlined,
                  activeIcon: Icons.icecream_rounded,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}