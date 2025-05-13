import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/components/resto_profile_card.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/models/cart_foodee_item.dart';
import 'package:rider_register/models/menu_item.dart';
import 'package:rider_register/models/packaging.dart';
import 'package:rider_register/models/restaurant.dart';
import 'package:rider_register/components/categories.dart';
import 'package:rider_register/repository/menu_item_repository.dart';
import 'package:rider_register/screens/foodee_inventory_screen.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:rider_register/widgets/sized_box_height.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';

import '../services/api_service.dart';
import '../theme/theme_helper.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantScreen extends StatefulWidget {
  final FoodeeItem? f;
  const RestaurantScreen({
    Key? key,
    this.f,
  }) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<FoodeeItem> _foodeeItems = [];
  List<FoodeeItem> _originalFoodeeItems = [];
  GoogleMapController? _mapController;
  LocationData? _currentPosition;
  ApiService apiService = ApiService();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //check if foodieItem is not null then setNumberCartFoodeeItem(foodeeItem) is called

      init();
      Future.delayed(Duration(seconds: 1), () {
        if (widget.f != null) {
          //PRINT f price
          print(widget.f!.price);
          // addToCartFoodeeItem(widget.f!);
          _moveFoodeeItemToFirst(widget.f!.name);
        }
      });
    });
    super.initState();
  }

  void _getCurrentPosition() async {
    // Get current location using Geolocator package
    _currentPosition = await Location().getLocation();
    print(
        "camera moved to ${_currentPosition!.latitude} ${_currentPosition!.longitude}");
    setState(() {
      context.read<DeliveryData>().setDepartLocationFoodee(
            LatLng(
              _currentPosition!.latitude!.toDouble(),
              _currentPosition!.longitude!.toDouble(),
            ),
          );
    });
    await apiService
        .getFormattedAddresses(LatLng(
      _currentPosition!.latitude!.toDouble(),
      _currentPosition!.longitude!.toDouble(),
    ))
        .then((value) {
      setState(() {
        context.read<DeliveryData>().setDepartAddressFoodee(value);
      });
    });
  }

  void recalculateTotal() {
    printanah('anah');
    int count = context.read<DeliveryData>().cartFoodeeItems.length;
    double total = 0;
    for (var i = 0; i < count; i++) {
      double price =
          context.read<DeliveryData>().cartFoodeeItems[i].foodeeItem.price;
      int size = context.read<DeliveryData>().cartFoodeeItems[i].size;
      printanah("$price * $size = ${price * size}");
      total += (price * size);
    }
    context.read<DeliveryData>().setCartFoodieTotalLocal(total);
    printanah('total: $total');
  }

  void setNumberCartFoodeeItem(FoodeeItem foodeeItem) async {
    // is in cart
    //// aaa : x <= 0
    //// bbb : 0 > x <= size
    //// ccc : x > size
    // not in cart
    //// ddd : x <= 0
    //// eee : 0 > x <= size
    //// fff : x > size
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Modifier'),
                onPressed: () async {
                  try {
                    int stock = int.parse(_stockController.text);
                    bool isInCartFoodeeItems = false;
                    int iCartFoodeeItem = 0;
                    for (int i = 0;
                        i < context.read<DeliveryData>().cartFoodeeItems.length;
                        i++) {
                      if (context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .foodeeItem
                              .id ==
                          foodeeItem.id) {
                        isInCartFoodeeItems = true;
                        iCartFoodeeItem = i;
                        break;
                      }
                    }
                    if (isInCartFoodeeItems) {
                      if (stock <= 0) {
                        context
                            .read<DeliveryData>()
                            .cartFoodeeItems[iCartFoodeeItem]
                            .size = 0;
                        context
                            .read<DeliveryData>()
                            .cartFoodeeItems
                            .removeAt(iCartFoodeeItem);
                      } else if (stock > 0 && stock <= foodeeItem.stock) {
                        context
                            .read<DeliveryData>()
                            .cartFoodeeItems[iCartFoodeeItem]
                            .size = stock;
                      } else {
                        context
                            .read<DeliveryData>()
                            .cartFoodeeItems[iCartFoodeeItem]
                            .size = foodeeItem.stock;
                        Future.delayed(
                          const Duration(milliseconds: 50),
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Stock limité")),
                            );
                          },
                        );
                      }
                    } else {
                      if (stock <= 0) {
                      } else if (stock > 0 && stock <= foodeeItem.stock) {
                        context.read<DeliveryData>().cartFoodeeItems.add(
                              CartFoodeeItem(
                                  foodeeItem: foodeeItem,
                                  note: "",
                                  size: stock),
                            );
                      } else {
                        printanah('message');
                        context.read<DeliveryData>().cartFoodeeItems.add(
                              CartFoodeeItem(
                                  foodeeItem: foodeeItem,
                                  note: "",
                                  size: foodeeItem.stock),
                            );
                        Future.delayed(
                          const Duration(milliseconds: 50),
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Stock limité")),
                            );
                          },
                        );
                      }
                    }
                    recalculateTotal();
                    _stockController.text = "";
                    Navigator.of(context).pop();
                  } catch (e) {
                    printanah(e.toString());
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Écriver un nombre entier'),
                    ));
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  void addToCartFoodeeItem(FoodeeItem foodeeItem) {
    print("add to cart");
    bool isInCartFoodeeItems = true;
    for (int i = 0;
        i < context.read<DeliveryData>().cartFoodeeItems.length;
        i++) {
      if (context.read<DeliveryData>().cartFoodeeItems[i].foodeeItem.id ==
          foodeeItem.id) {
        isInCartFoodeeItems = false;
        if (context.read<DeliveryData>().cartFoodeeItems[i].size >=
            foodeeItem.stock) {
          Future.delayed(
            const Duration(milliseconds: 50),
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Stock limité")),
              );
            },
          );
        } else {
          print("add to cart 2");
          Future.delayed(Duration.zero, () {
            setState(() {
              context.read<DeliveryData>().cartFoodeeItems[i].size++;
            });
          });
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value += foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        }
      }
    }
    if (isInCartFoodeeItems) {
      print("add to cart 3");
      Future.delayed(Duration.zero, () {
        setState(() {
          context.read<DeliveryData>().cartFoodeeItems.add(
                CartFoodeeItem(foodeeItem: foodeeItem, note: "", size: 1),
              );
        });
      });
      double value = context.read<DeliveryData>().cartFoodieTotalLocal;
      value = double.parse((value += foodeeItem.price).toStringAsFixed(2));
      print("price ${value}");

      context.read<DeliveryData>().setCartFoodieTotalLocal(value);
    }
  }

  void removeToCartFoodeeItem(FoodeeItem foodeeItem) {
    for (int i = 0;
        i < context.read<DeliveryData>().cartFoodeeItems.length;
        i++) {
      if (context.read<DeliveryData>().cartFoodeeItems[i].foodeeItem.id ==
          foodeeItem.id) {
        if (context.read<DeliveryData>().cartFoodeeItems[i].size == 1) {
          setState(() {
            context.read<DeliveryData>().cartFoodeeItems.removeAt(i);
          });
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value -= foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        } else if (context.read<DeliveryData>().cartFoodeeItems[i].size > 1) {
          setState(() {
            context.read<DeliveryData>().cartFoodeeItems[i].size--;
          });
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value -= foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        }
      }
    }
  }

  void emptyFoodeeitem() {
    context.read<DeliveryData>().setCartFoodeeItems([]);
  }

  void saveNoteCartFoodeeItem(
    FoodeeItem foodeeItem,
    String note,
    BuildContext context,
  ) {
    for (int i = 0;
        i < context.read<DeliveryData>().cartFoodeeItems.length;
        i++) {
      if (context.read<DeliveryData>().cartFoodeeItems[i].foodeeItem.id ==
          foodeeItem.id) {
        setState(() {
          context.read<DeliveryData>().cartFoodeeItems[i].note = note;
        });
        break;
      }
    }
    Navigator.pop(context);
  }

  void noteToCartFoodeeItem(FoodeeItem foodeeItem, CartFoodeeItem? c) {
    if (c == null) {
      Future.delayed(
        const Duration(milliseconds: 50),
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Note non possible")),
          );
        },
      );
    } else {
      String note = c.note;
      showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        backgroundColor: scheme.onPrimary,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 3,
                  ),
                ),
                const SizedBoxHeight(height: "sm"),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        note = text;
                      });
                    },
                    controller: TextEditingController()..text = note,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Add notes to your dish",
                      helperText: "Example: make my food spicy!",
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () => saveNoteCartFoodeeItem(
                    foodeeItem,
                    note,
                    context,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void getFilteredFoodeeItems(String category) {
    setState(() {
      if (category == 'Tout') {
        _foodeeItems = _originalFoodeeItems;
      } else {
        _foodeeItems = _originalFoodeeItems
            .where((item) => item.category == category)
            .toList();
      }
    });
  }

  void _moveFoodeeItemToFirst(String itemName) {
    setState(() {
      final itemIndex = _foodeeItems.indexWhere((item) => item.name == itemName);
      if (itemIndex != -1) {
        final item = _foodeeItems.removeAt(itemIndex);
        _foodeeItems.insert(0, item);
      }
    });
  }

  Future<void> init() async {
    // emptyFoodeeitem();
    context.read<DeliveryData>().setIsFetching(true);
    List<FoodeeItem> foodeeItems = await getFoodeeItemsByRestaurantId(
        context.read<DeliveryData>().orderingRestaurant!.id);
    setState(() {
      _foodeeItems = foodeeItems;
      _originalFoodeeItems = foodeeItems;
    });
    context.read<DeliveryData>().setIsFetching(false);
    // context.read<DeliveryData>().setCartFoodieTotalLocal(0);
  }

  void goToInventoryFoodee() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodeeInventoryScreen(),
      ),
    ).then((res) => init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          color: scheme.onPrimary,
          child: RefreshIndicator(
            onRefresh: () => init(),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetBanner(),
                      Divider(),
                      // WidgetHeader(),
                      // if (!context.read<DeliveryData>().isFetching)
                      //   WidgetDescription(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Categories(
                          isTitle: false,
                          onCategorySelected:
                              getFilteredFoodeeItems
                        ), // Pass the callback
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SliverPadding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0), // Ajoute une marge
                sliver:SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio:0.9, // Contrôle la largeur/hauteur des enfants
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return WidgetFoodCard(
                        foodeeItem: _foodeeItems[index],
                        addToCartFoodeeItem: addToCartFoodeeItem,
                        setNumberCartFoodeeItem: setNumberCartFoodeeItem,
                        removeToCartFoodeeItem: removeToCartFoodeeItem,
                        noteToCartFoodeeItem: noteToCartFoodeeItem,
                      );
                    },
                    childCount: _foodeeItems.length,
                  ),
                )),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // 
      floatingActionButton: 
      (context.read<DeliveryData>().cartFoodeeItems.length>0)?
      ElevatedButton(
         style: ElevatedButton.styleFrom(
          backgroundColor: scheme.inverseSurface, // Couleur de fond du bouton
          foregroundColor: scheme.inverseOnSurface, // Couleur du texte et des icônes
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Bord arrondi
          ),
          padding: EdgeInsets.only(left: 16, right:9), // Taille du bouton
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 56,
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          verticalDirection: VerticalDirection.down,
          children: [
            // Contenu gauche : Icône + Texte
            Row(
              children: [
                Icon(
                  Icons.approval_outlined, // Icône de repas
                  color: scheme.inverseOnSurface,
                  size: 24,
                ),
                SizedBox(width: 8), // Espacement entre l'icône et le texte
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${context.read<DeliveryData>().cartFoodeeItems.length} plat${(context.read<DeliveryData>().cartFoodeeItems.length>1)?'s':''}", // Exemple : "2 menus"
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.inverseOnSurface,
                          height: 1.1),
                    ),
                    Text(
                      "${context.read<DeliveryData>().cartFoodieTotalLocal.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar", // Exemple : "30 000 Ar"
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.inverseOnSurface,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
               decoration: BoxDecoration(
                color: scheme.primary, // Couleur de fond du bouton
                borderRadius: BorderRadius.circular(100), // Bord arrondi
              ),
              padding: EdgeInsets.symmetric(horizontal: 16), // Taille du bouton
              child: Container(
                height: 40,
                child:Row(
                  children: [ 
                    Icon(
                      Icons.shopping_cart_checkout_outlined, // Icône de repas
                      color: scheme.onPrimary,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Voir le panier",
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onPrimary,
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ]
                )
              )
            )                
          ],
        ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(left: 50.0), // Add right padding
          //           child: Text("xxx Commande"),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(left: 50.0), // Add right padding
          //           child: Text(
          //               "Chez ${context.read<DeliveryData>().orderingRestaurant!.name}"),
          //         ),
          //       ],
          //     ),
          //     Padding(
          //         padding: EdgeInsets.only(right: 50.0),
          //         child: Text(
          //             "Ar ${context.read<DeliveryData>().cartFoodieTotalLocal}")),
          //   ],
          // ),
        ),
        onPressed: context.read<DeliveryData>().cartFoodeeItems.isEmpty
            ? null
            : () => goToInventoryFoodee(),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class WidgetFoodCard extends StatelessWidget {
  FoodeeItem? foodeeItem;
  Function addToCartFoodeeItem;
  Function setNumberCartFoodeeItem;
  Function removeToCartFoodeeItem;
  Function noteToCartFoodeeItem;

  WidgetFoodCard({
    Key? key,
    required this.foodeeItem,
    required this.addToCartFoodeeItem,
    required this.setNumberCartFoodeeItem,
    required this.removeToCartFoodeeItem,
    required this.noteToCartFoodeeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartFoodeeItem? c;
    int itemLenght=0;
    try {
      c = context
          .read<DeliveryData>()
          .cartFoodeeItems
          .where((element) => element.foodeeItem.id == foodeeItem!.id)
          .first;
      //print every foodeeItem name
      print("foodee item " + foodeeItem!.name);
    } catch (e) {}
    if(c!=null){
        itemLenght = c.size;
    }
    return 
    // /*
    Container(
      // padding: EdgeInsets.only(bottom: 10),
      width: (MediaQuery.of(context).size.width /
              (Device.get().isTablet ? 3 : 2)) -
          12 -
          3,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          GestureDetector(
              // onTap: onPressed,
              child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: foodeeItem!.image,
              height: 100.0,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: 100.0,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )),
          const SizedBox(height: 8.0),
          // Nom du plat
          Text(
            foodeeItem!.name,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${foodeeItem!.price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                alignment: Alignment.center,
                // width: 96,
                height: 36,
                child:
                    //custom_input_number
                    Container(
                  // width: 120,

                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // border: Border.all(color: MaterialTheme.lightScheme().outlineVariant),
                    color: scheme.surfaceContainerLowest,
                  ),
                  child: (foodeeItem!.stock <= 0)
                      ? Center(
                          child: Text("Stock épuisé",
                              maxLines: 1,
                              overflow: TextOverflow
                                  .clip, // Coupe le texte si nécessaire
                              softWrap: false,
                              style:
                                  TextStyle(color: scheme.error, fontSize: 14)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 18,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                // border: Border.all(color: MaterialTheme.lightScheme().primary),
                                color: itemLenght > foodeeItem!.stock
                                    ? scheme.primary
                                    : scheme.primary.withOpacity(0.5),
                              ),
                              child: Center(
                                // Aligner l'icône au centre
                                child: GestureDetector(
                                  onTap: itemLenght > 0
                                      ? () => removeToCartFoodeeItem(foodeeItem)
                                      : null, // Action lorsque l'utilisateur appuie
                                  child: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            // Valeur actuelle

                            Container(
                                width: 32,
                                child: Center(
                                  child: GestureDetector(
                                     //onTap: () => setNumberCartFoodeeItem(foodeeItem),
                                    child: Text(c == null ? "0" : "${c.size}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          color: scheme.onSurface,
                                        )),
                                  ),
                                )),

                            // Bouton "+" avec un borderRadius et une bordure verte
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                // border: Border.all(color: scheme.primary),
                                color: scheme.primary,
                              ),
                              child: Center(
                                // Aligner l'icône au centre
                                child: GestureDetector(
                                  onTap: itemLenght <= foodeeItem!.stock
                                      ? ()=> addToCartFoodeeItem(foodeeItem)
                                      : null, // Action lorsque l'utilisateur appuie
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ))
          ])
        ],
      ),
    );
    // */
   /*
    Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                foodeeItem!.image,
              ),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBoxHeight(height: "xsm"),
        Text(foodeeItem!.name),
        Text(
          "Ar ${foodeeItem!.price}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          children: [
            const SizedBoxHeight(height: "xsm"),
            if (foodeeItem!.stock <= 0)
              const Text(
                "Stock épuisé",
                style: TextStyle(color: Colors.red),
              ),
            if (foodeeItem!.stock > 0)
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => noteToCartFoodeeItem(foodeeItem, c),
                      child: Icon(
                        Icons.library_books_outlined,
                        color: Colors.black54,
                        size: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    InkWell(
                      onTap: () => removeToCartFoodeeItem(foodeeItem),
                      child: Icon(
                        Icons.remove_circle_outline_outlined,
                        color: Colors.teal,
                        size: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    InkWell(
                      onTap: () => setNumberCartFoodeeItem(foodeeItem),
                      child: Text(c == null ? "0" : "${c.size}"),
                    ),
                    InkWell(
                      onTap: () => addToCartFoodeeItem(foodeeItem),
                      child: Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.teal,
                        size: MediaQuery.of(context).size.width * 0.04,
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ],
    );
    */
  }
}

class WidgetDescription extends StatelessWidget {
  const WidgetDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber[500],
                      size: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                        "${context.read<DeliveryData>().orderingRestaurant!.stars}"),
                  ],
                ),
                const SizedBoxHeight(height: "xsm"),
                Text("{Étoiles}"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: 1,
              child: const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      // check if distance is null
                      context
                                  .read<DeliveryData>()
                                  .orderingRestaurant!
                                  .distanceFromOrigin ==
                              null
                          ? "0"
                          : "${context.read<DeliveryData>().orderingRestaurant!.distanceFromOrigin}",
                    ),
                  ],
                ),
                const SizedBoxHeight(height: "xsm"),
                Text("Distance"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: 1,
              child: const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.wallet,
                      color: Colors.teal,
                      size: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      Restaurant.getDollardSymbole(
                        context
                            .read<DeliveryData>()
                            .orderingRestaurant!
                            .mostExpensivePrice,
                      ),
                      style: TextStyle(color: Colors.teal[300]),
                    ),
                    Text(
                      Restaurant.getDollardSymboleInverse(
                        context
                            .read<DeliveryData>()
                            .orderingRestaurant!
                            .mostExpensivePrice,
                      ),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBoxHeight(height: "xsm"),
                Text(
                  Restaurant.getAveragePrice(
                    context
                        .read<DeliveryData>()
                        .orderingRestaurant!
                        .higherPrice,
                    context.read<DeliveryData>().orderingRestaurant!.lowerPrice,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: 1,
              child: const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.width * 0.05,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        context
                            .read<DeliveryData>()
                            .orderingRestaurant!
                            .packaging!
                            .image,
                        // "https://img.icons8.com/fluency/1x/leaf.png",
                        // "https://img.icons8.com/external-flaticons-lineal-color-flat-icons/1x/external-biodegradable-vegan-and-vegetarian-flaticons-lineal-color-flat-icons-2.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
                const SizedBoxHeight(height: "xsm"),
                Text(
                    "${context.read<DeliveryData>().orderingRestaurant!.packaging!.name}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetHeader extends StatelessWidget {
  const WidgetHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.read<DeliveryData>().orderingRestaurant!.name),
            Text(context
                .read<DeliveryData>()
                .orderingRestaurant!
                .restaurantFoodType!
                .name),
          ],
        ),
      ),
    );
  }
}

class WidgetBanner extends StatelessWidget {
  const WidgetBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Container(
                height: 140,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(4), // Coins inférieurs arrondis
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6, // Flou de l'ombre
                      offset: Offset(0, 2), // Décalage vertical
                    ),
                  ],
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      context
                          .read<DeliveryData>()!
                          .orderingRestaurant!
                          .bannerPicture!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.vertical(
                //     bottom: Radius.circular(4), // Coins inférieurs arrondis
                //   ),
                //   child: Image.asset(
                //     imagePlat,
                //     width: double.infinity,
                //     height: 180,
                //     fit: BoxFit.cover,
                //   ),

                // )
              ),
              RestoProfileCard(
                nomResto: context.read<DeliveryData>().orderingRestaurant!.name,
                ouvert: true,
                description:
                    context.read<DeliveryData>().orderingRestaurant!.address +
                        " | " +
                        context
                            .read<DeliveryData>()
                            .orderingRestaurant!
                            .restaurantFoodType!
                            .name,
                star: 0.0,
                photoProfil: context
                    .read<DeliveryData>()
                    .orderingRestaurant!
                    .profilePicture,
              ),
            ])),
        // Bouton retour
        Positioned(
          top: 8,
          left: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Simule un retour en arrière
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(100), // Rond
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back, // Icône de retour
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
    // Contenu de la carte

    /*Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            context.read<DeliveryData>().orderingRestaurant!.bannerPicture,
          ),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
      ),
    );*/
  }
}
