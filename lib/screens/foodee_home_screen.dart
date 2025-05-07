import 'package:flutter/material.dart';
import '../components/search_bar.dart';
import '../components/tab_items.dart';
import '../components/categories.dart';
import '../components/address_position.dart';
import '../theme.dart';
import '../components/food_cards.dart';
import '../components/resto_cards.dart';
import '../components/head_foodee.dart';
import '../components/address_on_your_card.dart';
import '../theme/theme_helper.dart';

class FoodeeHomeScreen extends StatefulWidget {
  final int idService;

  const FoodeeHomeScreen({
    Key? key,
    this.idService = 0, // Default value
  }) : super(key: key);

  @override
  _FoodeeHomeScreenState createState() => _FoodeeHomeScreenState();
}

class _FoodeeHomeScreenState extends State<FoodeeHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Color appBarColor = scheme.surfaceContainerLowest; // Updated
  Color bodyColor = scheme.surfaceContainerLowest; // Updated
  int _selectedIndex = 0;
  bool noItems = false;
  String searchQuery = ''; // Add search query state
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      // appBarColor = _scrollController.offset > 50
      //     ? scheme.surface // Change to desired color when scrolled
      //     : scheme.surface; // Default AppBar color
    });
  }

  void _handleTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Tab changed to $index');
  }

  void _onVoirToutPressed() {
    // Handle the "Voir tout" button press
    if (_selectedIndex == 0) {
      // Fetch all items for FoodCards
      // Implement the logic to fetch all items
    } else if (_selectedIndex == 1) {
      // Fetch all items for RestoCards
      // Implement the logic to fetch all items
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bodyColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: Text(
          'Foodee',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          // padding: EdgeInsets.only(top: 16), // Reduced top padding due to AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressOnYourCard(adresse: "3GMQ 8H6, Antananarivo"),
              SearchBar(onSearch: _onSearch), // Pass the callback method
              TabItems(
                onTabChanged: _handleTabChange, // Pass the callback method
              ),
              HeadFoodee(
                index: _selectedIndex, // Pass the callback
              ),
              if (_selectedIndex == 0)
                FoodCards(searchQuery: searchQuery) // Pass the search query
              else if (_selectedIndex == 1)
                RestoCards(searchQuery: searchQuery),
              if (noItems)
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 56,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      'Aucun résultat trouvé',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
