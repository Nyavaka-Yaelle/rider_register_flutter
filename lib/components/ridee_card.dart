import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rider_register/theme/theme_helper.dart';

class RideeCard extends StatefulWidget {
  final String leftImage; // Image à gauche
  final String title; // Titre
  final String subtitle; // Sous-titre
  late final String rightImage; // Image à droite
  final double prix; // Image à droite

  RideeCard({
    Key? key,
    required this.leftImage,
    required this.title,
    required this.subtitle,
    this.rightImage = "",
    required this.prix,
  }) : super(key: key);

  @override
  _RideeCardState createState() => _RideeCardState();
}

class _RideeCardState extends State<RideeCard> {
  int state = 0; // État initial : 0 (default)

  /*
  0- default
  1- clicked
  2- loading
  3- refused  
  4- accepted
   */

  void onTap() {
    if (state == 0) {
      setState(() {
        state = 1; // Change l'état à 1 (clicked)
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // Déterminez les couleurs et widgets en fonction des états
    Color borderColor = scheme.outlineVariant;
    double elevation = 0;
    Color backgroundColor = scheme.surface;
    Widget? rightWidget;
    /*if (isLoading) {
      borderColor = scheme.primary.withOpacity(0.5);
      backgroundColor = scheme.surface.withOpacity(0.5);
      rightWidget = const CircularProgressIndicator(
        strokeWidth: 2,
      );
    } */
    if (state == 0) {
      borderColor = Colors.transparent;
      elevation = 2;
    } else if (state == 3) {
      borderColor = scheme.error;
    } else if (state == 4) {
      borderColor = scheme.primary;
    } else {
      borderColor = scheme.outlineVariant;
    }
    return GestureDetector(
        onTap: onTap,
        child: 
        
        Card(
          color: backgroundColor,
          elevation: elevation, // Shadow elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              width: 1, // Épaisseur de la bordure
              color: borderColor, // Couleur de la bordure
            ), // Border radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image à gauche dans un cercle
                  CircleAvatar(
                    radius: 24, // Taille du cercle
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(widget.leftImage),
                  ),
                  const SizedBox(
                      width: 16), // Espacement entre l'image et le texte
                  // Titre et sous-titre en colonne
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Image à droite dans un cercle
                  Text(
                    "${widget.prix.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                  ),
                  // CircleAvatar(
                  //   radius: 24, // Taille du cercle
                  //   backgroundImage: AssetImage(widget.rightImage),
                  //   backgroundColor: Colors.transparent, // Image à droite
                  // ),
                ],
              ),
              if (state > 0)
                Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.16, 
                        right: MediaQuery.of(context).size.width * 0.16, 
                        top: 8),
                    child: Divider()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (state == 1)
                    TextButton.icon(
                      onPressed: () {
                        print("Annuler ce rider !");
                        setState(() {
                          state = 0; // Change l'état à 1 (clicked)
                        });
                      },
                      icon: Icon(Icons.close,
                          size: 20, color: scheme.error),
                      label: Text(
                        "Annuler",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scheme.error,
                        ),
                      ),
                    ),
                  if (state == 1)
                    TextButton.icon(
                      onPressed: () {
                        print("Confirmer je prend ce rider !");
                        setState(() {
                          state = 2; // Change l'état à 1 (clicked)
                        });
                      },
                      icon: Icon(Icons.check,
                          size: 20,
                          color: scheme.primary),
                      label: Text(
                        "Confirmer",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  if (state == 2)
                    Row(children: [
                      SizedBox(
                        width: 12, // Largeur du loader
                        height: 12, // Hauteur du loader
                        child: CircularProgressIndicator(
                          strokeWidth: 2, // Épaisseur du cercle
                        ),
                      ),
                      SizedBox(width: 24),
                      Padding(padding: EdgeInsets.symmetric(vertical: 12.5), 
                      child:
                      Text("En attente de confirmation du Rider",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: scheme.secondary,
                          ))),
                    ]),
                  if (state == 3)
                    TextButton.icon(
                      onPressed: () {
                        print("Rider a refuse !");
                      },
                      icon: Icon(Icons.cancel_rounded,
                          size: 20, color: scheme.error),
                      label: Text(
                        "A refusé votre course",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scheme.error,
                        ),
                      ),
                    ),
                  if (state == 4)
                    TextButton.icon(
                      onPressed: () {
                        print("Rider a accepteee !");
                      },
                      icon: Icon(Icons.check_circle_rounded,
                          size: 20,
                          color: scheme.primary),
                      label: Text(
                        "A accepté votre course",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                ],
              )
            ]),
          ),
        ));
  }
}
