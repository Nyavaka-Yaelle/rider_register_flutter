import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'package:rider_register/screens/placearrive_screen.dart';
import 'package:rider_register/services/api_service.dart' as api_service;
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';
import 'package:rider_register/widgets/custom_icon_button.dart';
import 'package:rider_register/widgets/custom_text_form_field.dart';
import '../main.dart';

class Destination2Screen extends StatefulWidget {
  final String type;
  const Destination2Screen({super.key, required this.type});

  // Créer une classe qui hérite de StatefulWidget pour représenter l'écran avec état
  @override
  _Destination2ScreenState createState() => _Destination2ScreenState();
}

class _Destination2ScreenState extends State<Destination2Screen> {
  static bool? _isDepart = true;
  String toshowatfirst = "depart";
  bool? get isDepart => _isDepart;
  String verify = "";

  final _textControllerDepartRidee = TextEditingController();
  final _textControllerDeliveryRidee = TextEditingController();
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      elevation: 0,
      enableDrag: false,
      isScrollControlled: true,
      barrierColor: scheme.shadow.withAlpha(1),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 16.v,
        ),
        decoration: AppDecoration.fillBluegray5001.copyWith(
          borderRadius: BorderRadiusStyle.customBorderTL28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4.v,
                width: 32.h,
                decoration: BoxDecoration(
                  color: appTheme.gray600,
                  borderRadius: BorderRadius.circular(
                    2.h,
                  ),
                ),
              ),
            ),
            // SizedBox(height: 12.v),
            // Text(
            //   "Environ 5 min (1km)",
            //   style: theme.textTheme.bodyLarge,
            // ),
            SizedBox(height: 14.v),
            Text(
              "Laisser nous vous aider à trouver le chemin le plus rapide",
              // "Le chemin le plus rapide actuel",
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 20.v),
            // SizedBox(height: 10.v),
            CustomElevatedButton(
              text: "Valider",
              height: 35.h,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Destination3Screen(
                      type: widget.type,
                      depart: context.read<DeliveryData>().departLocationRidee!,
                      arrivee: context.read<DeliveryData>().multipoint![
                          context.read<DeliveryData>().multipoint!.length - 1],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 5.v)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      // _showBottomSheet();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<DeliveryData>().departLocationRidee != null &&
          context.read<DeliveryData>().multipointAddress != null) {
        // Check if current route is active and context is mounted
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          print(_textControllerDeliveryRidee.text + "bottom show");
          _showBottomSheet(context);
        }
      }
    });
  }

  //setter isDepart
  set isDepart(bool? value) {
    _isDepart = value;
  }

  // Créer une classe qui hérite de State pour gérer l'état du widget
  @override
  Widget build(BuildContext context) {
    final _textControllerDepartRidee = TextEditingController();
    final _textControllerDeliveryRidee = TextEditingController();
    if (isDepart == true) {
      toshowatfirst = "Point d'arrivée";
    } else {
      toshowatfirst = "Point de départ";
    }

    final departLocationRidee =
        context.watch<DeliveryData>().departLocationRidee;
    final deliveryLocationRidee =
        context.watch<DeliveryData>().deliveryLocationRidee;
    final departAddressRidee = context.watch<DeliveryData>().departAddressRidee;
    final deliveryAddressRidee =
        context.watch<DeliveryData>().deliveryAddressRidee;
    try {
      if (departLocationRidee != null) {
        //get city name
        if (departAddressRidee != null) {
          _textControllerDepartRidee.text = departAddressRidee;
        } else {
          api_service.ApiService()
              .getFormattedAddresses(departLocationRidee)
              .then((value) {
            _textControllerDepartRidee.text = value;
          });
        }
      }
      if (context.read<DeliveryData>().multipoint != null &&
          context.read<DeliveryData>().multipointAddress != null) {
        print("It's null");
        //get city name
        if (deliveryAddressRidee != null) {
          _textControllerDeliveryRidee.text = deliveryAddressRidee;
        } else if (context.read<DeliveryData>().multipointAddress != null) {
          _textControllerDeliveryRidee.text = context
                      .read<DeliveryData>()
                      .multipointAddress![
                  context.read<DeliveryData>().multipointAddress!.length - 1]
              ["address"];
        }
      }
      print(" is depart ${_textControllerDeliveryRidee.text}");
      print(deliveryAddressRidee);

      if (departLocationRidee != null && deliveryLocationRidee != null) {
        print("non null");
      }
    } catch (e, st) {
      print('Caught error: $e\n$st');
    }
    print("Result from PlacearriveScreen: $verify");

    return Scaffold(
      appBar: AppBar(
        title: (widget.type == "ridee" || widget.type == "caree")
            ? Text('Itinéraire')
            : Text('Où voulez-vous livrer votre colis?'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0 &&
              context.read<DeliveryData>().departLocationRidee != null &&
              context.read<DeliveryData>().multipointAddress != null) {
            // User swiped up
            _showBottomSheet(context);
            print("swiped up");
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text that say "Point de départ"
              // SizedBox(height: 25.0),
              // Padding(
              //     padding: EdgeInsets.only(
              //         right: MediaQuery.of(context).size.width * 0.45),
              //     child: Text(
              //       toshowatfirst,
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     )),
              // SizedBox(height: 25.0),

              Container(
                color: scheme.surface, // BOO
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 12.v),
                    SizedBox(height: 20.h),
                    // Icon(
                    //   Icons.arrow_back,
                    //   size: 25.h,
                    // ),
                    Row(
                      children: [
                        SizedBox(width: 32.v),
                        Icon(
                          Icons.my_location_outlined,
                          size: 25.h,
                          color: scheme.primary,
                        ),
                        SizedBox(width: 16.v),
                        CustomTextFormField(
                          readOnly: true,
                          onTap: () async {
                            print("test custom");
                            // Change isDepart to its opposite using the setter
                            isDepart = true;

                            print("is Depart $isDepart");
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            verify = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacearriveScreen(
                                  isDepart: isDepart!,
                                  type: widget.type,
                                ),
                              ),
                            );
                            if (verify == "ok") {
                              _showBottomSheet(context);
                            }
                            // Use the result from the pushed route
                          },
                          controller: _textControllerDepartRidee,
                          hintText: "Position de départ ",
                          width: 250.v,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      children: [
                        SizedBox(width: 32.v),
                        Icon(
                          Icons.location_on_outlined,
                          size: 25.h,
                          color: scheme.error,
                        ),
                        SizedBox(width: 16.v),
                        CustomTextFormField(
                          onTap: () async {
                            //change is depart to his opposite using the setter
                            isDepart = false;

                            print("is Depart $isDepart");
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            verify = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlacearriveScreen(
                                        isDepart: isDepart!,
                                        type: widget.type)));

                            if (verify == "ok") {
                              _showBottomSheet(context);
                            }
                          },
                          readOnly: true,
                          controller: _textControllerDeliveryRidee,
                          hintText: "Position d'arrivé",
                          textInputAction: TextInputAction.done,
                          width: 250.v,
                        ),
                      ],
                    ),
                    // SizedBox(height: 7.v),
                    SizedBox(height: 20.h),
                    // Container(
                    //   padding: EdgeInsets.all(8.h),
                    //   margin: EdgeInsets.only(left: 73.v, bottom: 7.v),
                    //   decoration: AppDecoration.fillBlueGray.copyWith(
                    //     borderRadius: BorderRadiusStyle.circleBorder18,
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       CustomImageView(
                    //         imagePath: ImageConstant.imgRideeTestGreen,
                    //         height: 17.v,
                    //         width: 25.h,
                    //         margin: EdgeInsets.only(bottom: 3.v),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.only(
                    //           left: 8.h,
                    //           bottom: 1.v,
                    //         ),
                    //         child: Text(
                    //           "5 min",
                    //           style: CustomTextStyles.titleSmallGray900,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),

              // Créer un conteneur avec deux entrées en lecture seule
              // Container(
              //   width: 350,
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       // Créer une bordure verte
              //       border: Border.all(color: Colors.green, width: 2),
              //       // Colorer l'arrière-plan en gris
              //       color: Colors.grey.shade300),
              //   child: Column(
              //     children: [
              //       // Créer la première entrée en lecture seule
              //       TextFormField(
              //         onTap: () {
              //           //change is depart to his opposite using the setter
              //           isDepart = true;

              //           print("is Depart $isDepart");
              //           Future.delayed(const Duration(milliseconds: 500), () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => PlacearriveScreen(
              //                         isDepart: isDepart!, type: widget.type)));
              //           });
              //         },
              //         controller: _textControllerDepartRidee,
              //         readOnly: true,
              //         decoration: InputDecoration(
              //           hintText: 'Point de départ',
              //           prefixIcon: Transform.scale(
              //             scale: 0.5, // Change this value to shrink the icon
              //             child: ImageIcon(
              //               AssetImage('assets/logo/user.png'),
              //               color: Colors.green,
              //             ),
              //           ),
              //         ),
              //       ),

              //       // Créer la deuxième entrée en lecture seule
              //       TextFormField(
              //         onTap: () {
              //           //change is depart to his opposite using the setter
              //           isDepart = false;

              //           print("is Depart $isDepart");
              //           Future.delayed(const Duration(milliseconds: 500), () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => PlacearriveScreen(
              //                         isDepart: isDepart!, type: widget.type)));
              //           });
              //         },
              //         controller: _textControllerDeliveryRidee,
              //         readOnly: true,
              //         decoration: InputDecoration(
              //             hintText: "Point d'arrivée",
              //             prefixIcon: Transform.scale(
              //               scale: 0.5, // Change this value to shrink the icon
              //               child: ImageIcon(
              //                 AssetImage('assets/logo/Arriver.png'),
              //                 color: Colors.red,
              //               ),
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 25),
              // // Créer un bouton aligné à gauche qui dit "Pointer sur la carte"
              // Padding(
              //   padding: EdgeInsets.only(
              //       right: MediaQuery.of(context).size.width * 0.39),
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       //change is depart to his opposite using the setter
              //       isDepart = !isDepart!;

              //       print("is Depart $isDepart");
              //       Future.delayed(const Duration(milliseconds: 500), () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => PlacearriveScreen(
              //                     isDepart: isDepart!, type: widget.type)));
              //       });
              //     }, // Vous pouvez ajouter du code ici pour changer l'état du widget lorsque le bouton est appuyé
              //     icon: Icon(Icons.map),
              //     label: Text('Pointer sur la carte',
              //         style: TextStyle(fontSize: 16)),
              //   ),
              // ),

              SizedBox(height: 25),
              // Créer une liste de choses aléatoires avec une image arrondie et un texte à côté
              // ListView.builder(
              //   //spacing between items
              //   shrinkWrap:
              //       true, // Permettre au ListView de s'adapter à son contenu
              //   itemCount:
              //       3, // Utiliser trois éléments comme exemple (vous pouvez changer ce nombre)
              //   itemBuilder: (context, index) {
              //     // Construire chaque élément de la liste
              //     return ListTile(
              //       //spacing between items
              //       contentPadding:
              //           EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              //       leading: CircleAvatar(
              //         // Créer une image arrondie avec le widget CircleAvatar
              //         radius:
              //             32, // Définir le rayon de l'image à 32 (ce qui donne une taille de 64x64)
              //         backgroundImage: NetworkImage(
              //             'https://picsum.photos/200'), // Utiliser une image aléatoire depuis internet (vous pouvez changer l'url)
              //       ),
              //       title: Text(
              //           'Chose aléatoire $index'), // Créer un texte à côté de l'image
              //     );
              //   },
              // ),

              // Stack(
              //   children: [
              //     // Vos widgets ici
              //     Visibility(
              //       visible: departLocationRidee != null &&
              //           context.watch<DeliveryData>().multipointAddress != null,
              //       child: Align(
              //         alignment: Alignment.bottomRight,
              //         child: SizedBox(
              //           width: 100,
              //           child: FloatingActionButton(
              //             onPressed: () {
              //               // Future delay to wait for the state to be updated
              //               Future.delayed(const Duration(milliseconds: 500), () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) => Destination3Screen(
              //                             type: widget.type,
              //                             depart: departLocationRidee!,
              //                             arrivee: context
              //                                 .watch<DeliveryData>()
              //                                 .multipoint![context
              //                                     .watch<DeliveryData>()
              //                                     .multipoint!
              //                                     .length -
              //                                 1])));
              //               });
              //             },
              //             child: Icon(Icons.add),
              //             backgroundColor: Colors.blue,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
