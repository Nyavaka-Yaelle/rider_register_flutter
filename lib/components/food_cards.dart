import 'package:flutter/material.dart';
import './custom_item.dart';
import './custom_icon_button.dart';
import './food_card.dart';
import './resto_card.dart';
import '../theme.dart'; // Importez le fichier TabItem si nécessaire

//foodee requirement 
import 'package:rider_register/repository/menu_item_repository.dart';
import 'package:rider_register/models/menu_item.dart';
import 'package:rider_register/screens/restaurant_screen.dart';
import 'package:rider_register/repository/restaurant_repository.dart';
import 'package:rider_register/screens/food_card_extended.dart';
import 'package:provider/provider.dart';
//importing main.dart
import 'package:rider_register/main.dart';
import 'package:skeletons/skeletons.dart';

class FoodCards extends StatefulWidget {
  final String? searchQuery; // Make searchQuery optional
  final Function(bool)? onItemsFetched; // Callback pour notifier si aucun élément

 const FoodCards({
    Key? key,
    required this.searchQuery,
     this.onItemsFetched, // Ajout du callback
  }) : super(key: key);

  @override
  _FoodCardsState createState() => _FoodCardsState();
}

class _FoodCardsState extends State<FoodCards> {
  List<FoodeeItem> _randomItems = [];
  bool isLoading = true; // Add a loading state
  bool isFetching = false; // Add a fetching state for onPressed

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      isLoading = true;
    });
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      await _fetchItemsByQuery(widget.searchQuery!);
    } else {
      await _fetchRandomItems();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchRandomItems() async {
    final items = await getXRandomItems(6);
    setState(() {
      _randomItems = items;
    });
  }

  Future<void> _fetchItemsByQuery(String query) async {
    final items = await searchMenuItems(query);
    setState(() {
      _randomItems = items;
    });
     // Notifier FoodeeHomeScreen si aucun élément n'est trouvé
    if (widget.onItemsFetched != null) {
      widget.onItemsFetched!(_randomItems.isEmpty);
    }
  }

  @override
  void didUpdateWidget(FoodCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchItems(); // Fetch new items when the search query changes
    }
  }

  @override
  Widget build(BuildContext context) {
     if (_randomItems.isEmpty) {
      return Container(
              // padding: EdgeInsets.symmetric(horizontal:12),
              width: MediaQuery.of(context).size.width,
              child:isLoading
          ? _buildSkeletonCards()
          : Container(
        height: MediaQuery.of(context).size.height / 2,
        child:Center(
        child: Text(
          'Aucun plat trouvé',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      )));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal:12),
      width: MediaQuery.of(context).size.width,
      child: isLoading
          ? _buildSkeletonCards()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6.0, // Espace horizontal entre les éléments
                runSpacing: 16.0, // Espace vertical entre les lignes d'éléments
                children: _randomItems.map((item) {
                  return FoodCard(
                    foodeeItem: item,
                    nomPlat: item.name,
                    nomResto: item.restaurantName ?? "Restaurant",
                    // nomResto: item.description, // Assuming you have restaurantName in FoodeeItem
                    imageResto: item.imageResto,
                    
                    prix: item.price,
                    imagePlat: item.image,
                    star: 4.5, // Assuming you have rating in FoodeeItem
                    onPressed: () {
                      setState(() {
                        isFetching = true;
                      });
                      getRestaurantByReference(item.restaurantId).then((value) {
                        setState(() {
                          isFetching = false;
                        });
                        print(value!.name);
                        context.read<DeliveryData>().setOrderingRestaurant(value!);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600), // Adjust the duration here
                            pageBuilder: (context, animation, secondaryAnimation) => FoodCardExtended(
                              foodeeItem: item,
                              nomPlat: item.name,
                              nomResto: value.name,
                              descriptionPlat: item.description,
                              descriptionResto: value.name,
                              imagePlat: item.image,
                              imageResto: value.profilePicture,
                              prix: item.price,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      });
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }

  /*Widget _buildSkeletonCards() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 16.0,
      children: List.generate(6, (index) {
        return SkeletonItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    height: 100.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: 100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 4.0),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 14,
                  width: 150,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 8.0),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: 50,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
*/
  Widget _buildSkeletonCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 189,
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4, // Number of skeleton items to show
        itemBuilder: (context, index) {
          return SkeletonItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: double.infinity,
                      height: 100.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                // Nom du plat
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                    width: 100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 4.0),
                // Nom du restaurant + étoiles
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 20.0,
                          height: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 14,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        SizedBox(width: 1.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 12,
                              width: 20,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Prix + Bouton Commander
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 50,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 26.0,
                        height: 26.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
