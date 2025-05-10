import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/components/custom_button.dart';
import 'package:rider_register/components/resto_on_your_card.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/models/cart_foodee_item.dart';
import 'package:rider_register/models/menu_item.dart';
import 'package:rider_register/models/restaurant.dart';
import 'package:rider_register/screens/foodee_order_status.dart';
import 'package:rider_register/screens/placedepart_foodee_screen.dart';
import 'package:rider_register/theme/theme_helper.dart';
import 'package:rider_register/widgets/sized_box_height.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/commande.dart';
import '../models/livraison.dart';
import '../repository/commande_repository.dart';
import '../repository/livraison_repository.dart';
import '../repository/user_repository.dart';
import 'destination3loading_screen.dart';

class FoodeeInventoryScreen extends StatefulWidget {
  const FoodeeInventoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FoodeeInventoryScreen> createState() => _FoodeeInventoryScreenState();
}

class _FoodeeInventoryScreenState extends State<FoodeeInventoryScreen> {
  Restaurant? _restaurant;
  String _orderTypeChoose = "delivery";
  //loop through the cartFoodeeItems and add the items to the firestore
  void _simulateBackButton() {
    Navigator.pop(context);
  }

  void addToCartFoodeeItem(FoodeeItem foodeeItem) {
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
          setState(() {
            context.read<DeliveryData>().cartFoodeeItems[i].size++;
          });
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value += foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        }
      }
    }
    if (isInCartFoodeeItems) {
      setState(() {
        context.read<DeliveryData>().cartFoodeeItems.add(
              CartFoodeeItem(foodeeItem: foodeeItem, note: "", size: 1),
            );
      });
      double value = context.read<DeliveryData>().cartFoodieTotalLocal;
      value = double.parse((value += foodeeItem.price).toStringAsFixed(2));
      context.read<DeliveryData>().setCartFoodieTotalLocal(value);
    }
  }
 void removeAllToCartFoodeeItem(FoodeeItem foodeeItem) {
    for (int i = 0;
        i < context.read<DeliveryData>().cartFoodeeItems.length;
        i++) {
        if (context.read<DeliveryData>().cartFoodeeItems[i].size >= 1) {
          setState(() {
            context.read<DeliveryData>().cartFoodeeItems.removeAt(i);
          });
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value -= foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        } 
          double value = context.read<DeliveryData>().cartFoodieTotalLocal;
          value = double.parse((value -= foodeeItem.price).toStringAsFixed(2));
          context.read<DeliveryData>().setCartFoodieTotalLocal(value);
        
      
    }
    if (context.read<DeliveryData>().cartFoodeeItems.isEmpty) {
      Navigator.pop(context, () {
        setState(() {});
      });
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
    if (context.read<DeliveryData>().cartFoodeeItems.isEmpty) {
      Navigator.pop(context, () {
        setState(() {});
      });
    }
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

  void setOrderType(String orderType) {
    setState(() {
      _orderTypeChoose = orderType;
    });
  }

  void showOrderTypeModalBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.05,
        ),
      ),
      context: context,
      builder: (
        BuildContext context,
      ) {
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
              const Text("Choisissez le type de commande"),
              const SizedBoxHeight(height: "sm"),
              Container(
                width: MediaQuery.of(context).size.width * 0.96,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetButtonOrderType(
                          orderType: "delivery",
                          orderTypeChoose: _orderTypeChoose,
                          setOrderType: setOrderType,
                        ),
                        WidgetButtonOrderType(
                          orderType: "pickup",
                          orderTypeChoose: _orderTypeChoose,
                          setOrderType: setOrderType,
                        ),
                      ],
                    ),
                    const SizedBoxHeight(height: "sm"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          child: const Text('Annuler'),
                          onPressed: () => null,
                        ),
                        ElevatedButton(
                          child: const Text('Confirmer'),
                          onPressed: () => null,
                        ),
                      ],
                    ),
                    const SizedBoxHeight(height: "md"),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
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
                      labelText: "Ajouter des notes à votre plat",
                      helperText: "Exemple: Rendez mon plat épicé!",
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Sauver'),
                  onPressed: () =>
                      saveNoteCartFoodeeItem(foodeeItem, note, context),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> init() async {
    var _currentPosition = await Location().getLocation();
    setState(() {
      _restaurant = context.read<DeliveryData>().orderingRestaurant;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24.0,
            color: scheme.onSurfaceVariant,
          ), // Flèche "Retour"
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // backgroundColor: appBarColor,
        backgroundColor: scheme.surfaceContainerLowest,

        elevation: 0,
        title: Text(
          'Votre panier',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22.0,
            color: scheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => init(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // const SizedBoxHeight(height: "sm"),
                    WidgetHeader(widget: widget),
                    // const SizedBoxHeight(height: "sm"),
                    const WidgetDivider(),
                    const SizedBox(height: 8),
                    WidgetChooseDestination(),
                    const SizedBox(height: 8),
                    const WidgetDivider(),
                    const SizedBox(height: 8),
                    //changer de service
                    // WidgetChooseRider(
                    //   showOrderTypeModalBottomSheet:
                    //       showOrderTypeModalBottomSheet,
                    //   orderTypeChoose: _orderTypeChoose,
                    // ),
                    // const SizedBox(height:8),
                    // const WidgetDivider(),
                    // WidgetNoteDestination(),
                    const SizedBoxHeight(height: "sm"),
                    WidgetFoodItem(
                      addToCartFoodeeItem: addToCartFoodeeItem,
                      noteToCartFoodeeItem: noteToCartFoodeeItem,
                      removeToCartFoodeeItem: removeToCartFoodeeItem,
                      removeAllToCartFoodeeItem: removeAllToCartFoodeeItem,
                    ),
                    const SizedBoxHeight(height: "sm"),
                    // DESCRIPTION
                    //Résumé de paiement
                    /*
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.01),
                        border: Border.all(
                          color: Colors.black12,
                          width: MediaQuery.of(context).size.width * 0.005,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: Column(children: [
                          // Text("Payment summary"),
                          Text("Résumé de paiement"),
                          Table(
                            defaultColumnWidth: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.42,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  // Text('Price'),
                                  Text('Prix'),
                                  Text(
                                    "${context.read<DeliveryData>().cartFoodieTotalLocal}",
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              // TableRow(
                              //   children: [
                              //     Text('Delivery fee'),
                              //     Text(
                              //       '{Delivery fee}',
                              //       textAlign: TextAlign.right,
                              //     )
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     Text('Service and other fees'),
                              //     Text(
                              //       '{Service and other fees}',
                              //       textAlign: TextAlign.right,
                              //     ),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     Text(
                              //       'Total payment',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     Text(
                              //       '${context.read<DeliveryData>().cartFoodieTotalLocal} Ar',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //       textAlign: TextAlign.right,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ]),
                      ),
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: WidgetEMoney(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class WidgetButtonOrderType extends StatelessWidget {
  final String orderType;
  final String orderTypeChoose;
  final Function setOrderType;
  const WidgetButtonOrderType({
    super.key,
    required this.orderType,
    required this.orderTypeChoose,
    required this.setOrderType,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    String orderTypeImage = "";
    if (orderType == "delivery") {
      orderTypeImage = "Ridee-1.png";
    } else if (orderType == "pickup") {
      orderTypeImage = "Packee.png";
    }

    return Container(
      color:
          orderType == orderTypeChoose ? Colors.teal[100] : Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.46,
      child: OutlinedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/logo/$orderTypeImage',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Column(
              children: [
                Text(orderType),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                const Text('{In 26 mn}'),
              ],
            ),
          ],
        ),
        onPressed: () {
          setOrderType(orderType);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class WidgetEMoney extends StatefulWidget {
  const WidgetEMoney({
    super.key,
  });

  @override
  State<WidgetEMoney> createState() => _WidgetEMoneyState();
}

class _WidgetEMoneyState extends State<WidgetEMoney> {
  void sendOrder(
      List<String>? items,
      List<int>? quantites,
      List<double>? prix,
      String? iduser,
      String? idrider,
      String? restaurantId,
      Timestamp? dateenregistrement,
      List<String>? notesitems) async {
    Commande commande = Commande(
      items: items,
      quantites: quantites,
      prix: prix,
      iduser: iduser,
      idrider: idrider,
      restaurantId: restaurantId,
      dateenregistrement: dateenregistrement,
      notesitems: notesitems,
    );
    goToStatusOrder(commande);
  }

  void goToStatusOrder(Commande c) async {
    Restaurant r = context.read<DeliveryData>().orderingRestaurant!;
    LatLng restaurantcoordinate =
        LatLng(r.location.latitude, r.location.longitude);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Destination3loadingScreen(
                depart: restaurantcoordinate,
                commande: c,
                type: "foodee",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String>? items = [];
    List<String>? notesitems = [];
    List<int>? quantites = [];
    List<double>? prix = [];
    String? iduser;
    String? idrider;
    String? restaurantId;
    Timestamp? dateenregistrement;
    UserRepository userRepository = new UserRepository();
    return
        //fab taloha
        Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 88,
              // padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.1),
                //     blurRadius: 8.0,
                //     spreadRadius: 2.0,
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${context.read<DeliveryData>().cartFoodieTotalLocal.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                        // '${value.toStringAsFixed(0)} Ar', // Affichage du montant avec 'FCFA'
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    label: "Commander",
                    color: scheme.primary,
                    onPressed: () {
                      try {
                        items = [];
                        quantites = [];
                        prix = [];
                        notesitems = [];

                        for (int i = 0;
                            i <
                                context
                                    .read<DeliveryData>()
                                    .cartFoodeeItems
                                    .length;
                            i++) {
                          print(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .foodeeItem
                              .name);
                          items!.add(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .foodeeItem
                              .name);
                          quantites!.add(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .size);
                          prix!.add(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .foodeeItem
                              .price);
                          notesitems!.add(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .note);
                          print(context
                              .read<DeliveryData>()
                              .cartFoodeeItems[i]
                              .note);
                        }
                        iduser = userRepository.getCurrentUser()!.uid;
                        restaurantId =
                            context.read<DeliveryData>().orderingRestaurant!.id;
                        dateenregistrement = Timestamp.now();
                        idrider = "null";
                        sendOrder(items, quantites, prix, iduser, idrider,
                            restaurantId, dateenregistrement, notesitems);
                      } catch (e, st) {
                        print('Caught error: $e\n$st');
                      }
                    },
                  ),
                ],
              ),
            ));
    /*Card(
      shadowColor: Colors.teal,
      elevation: MediaQuery.of(context).size.width * 0.01,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.teal,
          width: MediaQuery.of(context).size.width * 0.005,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            MediaQuery.of(context).size.width * 0.005,
          ),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.98,
        height: 96,//MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.05,
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/logo/Monee-1.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      const Text(
                        "Cash",
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Total: Ar ${context.read<DeliveryData>().cartFoodieTotalLocal}",
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    items = [];
                    quantites = [];
                    prix = [];
                    notesitems = [];

                    for (int i = 0;
                        i < context.read<DeliveryData>().cartFoodeeItems.length;
                        i++) {
                      print(context
                          .read<DeliveryData>()
                          .cartFoodeeItems[i]
                          .foodeeItem
                          .name);
                      items!.add(context
                          .read<DeliveryData>()
                          .cartFoodeeItems[i]
                          .foodeeItem
                          .name);
                      quantites!.add(
                          context.read<DeliveryData>().cartFoodeeItems[i].size);
                      prix!.add(context
                          .read<DeliveryData>()
                          .cartFoodeeItems[i]
                          .foodeeItem
                          .price);
                      notesitems!.add(
                          context.read<DeliveryData>().cartFoodeeItems[i].note);
                      print(
                          context.read<DeliveryData>().cartFoodeeItems[i].note);
                    }
                    iduser = userRepository.getCurrentUser()!.uid;
                    restaurantId =
                        context.read<DeliveryData>().orderingRestaurant!.id;
                    dateenregistrement = Timestamp.now();
                    idrider = "null";
                    sendOrder(items, quantites, prix, iduser, idrider,
                        restaurantId, dateenregistrement, notesitems);
                  } catch (e, st) {
                    print('Caught error: $e\n$st');
                  }
                },
                child: Text("Commander"),
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}

class WidgetFoodItem extends StatelessWidget {
  Function addToCartFoodeeItem;
  Function noteToCartFoodeeItem;
  Function removeToCartFoodeeItem;
  Function removeAllToCartFoodeeItem;
  WidgetFoodItem({
    super.key,
    required this.addToCartFoodeeItem,
    required this.removeToCartFoodeeItem,
    required this.removeAllToCartFoodeeItem,
    required this.noteToCartFoodeeItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (1 - 0.95),
      ),
      itemCount: context.read<DeliveryData>().cartFoodeeItems.length,
      itemBuilder: (BuildContext context, int index) {
        CartFoodeeItem cartFoodeeItem =
            context.read<DeliveryData>().cartFoodeeItems[index];
        FoodeeItem foodeeItem = cartFoodeeItem.foodeeItem;
        return

//new design card des foods dans panoer
            Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligner tout en haut
            children: [
              // Image du plat
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        foodeeItem.image), // Image du plat
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Informations du plat (Nom et prix)
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligner le texte à gauche
                  children: [
                    Text(
                      foodeeItem.name,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${foodeeItem.price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // Icône Time (en haut à droite)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 56),
                       child: 
                       GestureDetector(
                          onTap: ()=>removeAllToCartFoodeeItem(foodeeItem), 
                          child:Icon(
                            Icons.close_outlined,
                            color: scheme.onSurfaceVariant,
                            size: 20,
                      ))),
                  SizedBox(height: 4),
                  // Input type number pour ajuster la quantité
                  Padding(
                    padding: EdgeInsets.only(top: 24, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 18,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // border: Border.all(color: MaterialTheme.lightScheme().primary),
                            color: scheme.primary,
                          ),
                          child: Center(
                            // Aligner l'icône au centre
                            child: GestureDetector(
                              onTap: ()=>removeToCartFoodeeItem(
                                  foodeeItem), // Action lorsque l'utilisateur appuie
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
                                child: Text("${cartFoodeeItem.size}",
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
                              onTap: () => addToCartFoodeeItem(
                                  foodeeItem), // Action lorsque l'utilisateur appuie
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
                  )
                ],
              ),
            ],
          ),
        );

        //card food eo am panier
        /*
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  foodeeItem.name,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    foregroundColor: Colors.grey,
                  ),
                  label: Icon(
                    Icons.library_books_outlined,
                    size: 16,
                  ),
                  icon: Text('Note'),
                  onPressed: () => noteToCartFoodeeItem(
                    foodeeItem,
                    cartFoodeeItem,
                  ),
                ),
                Text(
                  "Ar ${foodeeItem.price}",
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
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
                        foodeeItem.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
                const SizedBoxHeight(height: "xsm"),
                Column(
                  children: [
                    const SizedBoxHeight(height: "xsm"),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => removeToCartFoodeeItem(foodeeItem),
                            child: Icon(
                              Icons.remove_circle_outline_outlined,
                              color: Colors.teal,
                              size: MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          Text("${cartFoodeeItem.size}"),
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
            ),
          ],
        );*/
      },
      separatorBuilder: (BuildContext context, int index) => Column(
        children: const [
          SizedBoxHeight(height: "sm"),
          WidgetDivider(),
          SizedBoxHeight(height: "sm"),
        ],
      ),
    );
  }
}

class WidgetNoteDestination extends StatelessWidget {
  const WidgetNoteDestination({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _noteController = TextEditingController();
    if (context.read<DeliveryData>().noteRidee != null) {
      _noteController.text = context.read<DeliveryData>().noteRidee!;
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.15,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        controller: _noteController,
        onChanged: (value) {
          context.read<DeliveryData>().setNoteRidee(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Add notes to your destination",
          helperText: "Example: In front of the super market!",
        ),
      ),
    );
  }
}

class WidgetChooseDestination extends StatefulWidget {
  const WidgetChooseDestination({
    super.key,
  });

  @override
  State<WidgetChooseDestination> createState() =>
      _WidgetChooseDestinationState();
}

class _WidgetChooseDestinationState extends State<WidgetChooseDestination> {
  bool show = false;

  Future<void> showOriginAddresses(String originAddresses) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adresse'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(originAddresses),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _noteController = TextEditingController();
    if (context.read<DeliveryData>().noteRidee != null) {
      _noteController.text = context.read<DeliveryData>().noteRidee!;
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.06,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Première ligne: icône de localisation, adresse et icône d'édition
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 24,
                  color: scheme.error,
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adresse de livraison",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Roboto',
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      context.watch<DeliveryData>().departAddressFoodee ??
                          "Votre position",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        height: 1.33,
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
                onTap: () => {
                      //Future delayed 500 ms and navigate push to the page
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlacedepartFoodeeScreen(),
                          ),
                        );
                      }),
                    },
                child: Icon(
                  Icons.edit_location_alt_outlined,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                )),
          ],
        ),
        const SizedBox(height: 8.0), // Espacement entre les lignes

        // Deuxième ligne: icône de détail et texte au centre
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Permet de ne pas étirer la ligne
            children: [
              Icon(Icons.description_outlined,
                  color: scheme.secondary, size: 16),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: () => {
                  setState(
                    () => show = !show,
                  )
                },
                child: Text(
                  !show ? 'Un détail à l\'adresse ?' : 'Enregistrer ce détail',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontFamily: 'Roboto',
                    color: scheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        show
            ? Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                // height: 72,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  // maxLines: 10,
                  controller: _noteController,
                  onChanged: (value) {
                    context.read<DeliveryData>().setNoteRidee(value);
                  },
                  decoration: InputDecoration(
                    // border: UnderlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: scheme.secondary, // Couleur de la bordure
                    //     width: 1.0, // Épaisseur de la bordure
                    //   ),
                    // ),
                    border: OutlineInputBorder(),
                    labelText: "Exemple: en face du supermarché!",
                    // helperText: "Exemple: en face du supermarché!",
                  ),
                ),
              )
            : SizedBox.shrink()
      ]),
      /*
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.01,
              ),
              InkWell(
                onTap: () {
                  if (context.read<DeliveryData>().departAddressFoodee !=
                      null) {
                    showOriginAddresses(
                        context.read<DeliveryData>().departAddressFoodee!);
                  } else {
                    showOriginAddresses("No address");
                  }
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.height * 0.15,
                    child: Text(
                        context.watch<DeliveryData>().departAddressFoodee ??
                            "")),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Changer l\'adresse'),
            onPressed: () => {
              //Future delayed 500 ms and navigate push to the page
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacedepartFoodeeScreen(),
                  ),
                );
              }),
            },
          ),
        ],
      ),*/
    );
  }
}

class WidgetChooseRider extends StatelessWidget {
  Function showOrderTypeModalBottomSheet;
  String orderTypeChoose;

  WidgetChooseRider({
    super.key,
    required this.showOrderTypeModalBottomSheet,
    required this.orderTypeChoose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.width * 0.08),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      orderTypeChoose == "delivery"
                          ? "assets/logo/Ridee-1.png"
                          : "assets/logo/Packee.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.01,
              ),
              orderTypeChoose == "delivery"
                  ? Text("Rider (Plus rapide)")
                  : Text("Pickup (Prendre chaud)"),
            ],
          ),
          ElevatedButton(
            child: const Text('Changer de service'),
            onPressed: () => showOrderTypeModalBottomSheet(),
          ),
        ],
      ),
    );
  }
}

class WidgetHeader extends StatelessWidget {
  const WidgetHeader({
    super.key,
    required this.widget,
  });

  final FoodeeInventoryScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 16, 16),

        // color: Colors.red,
        width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.06,
        child: RestoOnYourCard(
            nomResto: context.read<DeliveryData>().orderingRestaurant!.name,
            imageResto:
                context.read<DeliveryData>().orderingRestaurant!.profilePicture,
            description: context
                .read<DeliveryData>()
                .orderingRestaurant!
                .restaurantFoodType!
                .name)
        /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(context.read<DeliveryData>().orderingRestaurant!.name),
              Text(context
                  .read<DeliveryData>()
                  .orderingRestaurant!
                  .restaurantFoodType!
                  .name),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: Colors.amber[500],
              ),
              Text("${context.read<DeliveryData>().orderingRestaurant!.stars}"),
            ],
          ),
        ],
      ),*/
        );
  }
}

class WidgetDivider extends StatelessWidget {
  const WidgetDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 0.2,
      child: Divider(
        thickness: 0.2,
        color: scheme.outline,
      ),
    );
  }
}
