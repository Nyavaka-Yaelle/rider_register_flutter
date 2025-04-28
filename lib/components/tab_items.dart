import 'package:flutter/material.dart';
import 'tab_item.dart'; // Importez le fichier TabItem si nécessaire

class TabItems extends StatefulWidget {
  final ValueChanged<int> onTabChanged; // Callback pour informer le parent

  const TabItems({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  _TabItemsState createState() => _TabItemsState();
}

class _TabItemsState extends State<TabItems> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TabItem(
            label: 'Menus',
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book_rounded,
            isSelected: _selectedIndex == 0,
            onTap: () => _onTabSelected(0),
          ),
        ),
        Expanded(
          child: TabItem(
            label: 'Restaurants',
            icon: Icons.restaurant_outlined,
            activeIcon: Icons.restaurant_rounded,
            isSelected: _selectedIndex == 1,
            onTap: () => _onTabSelected(1),
          ),
        ),
        // SizedBox(width: 16.0),
      ],
    );
  }
}
