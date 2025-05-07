import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';
import '../components/custom_button.dart'; // Assurez-vous que vous avez importé votre CustomButton
import '../components/horizontal_line.dart'; // Assurez-vous que vous avez importé votre CustomButton
import '../theme.dart';
import 'package:rider_register/screens/restaurant_screen.dart';
import 'package:rider_register/models/menu_item.dart';

class FoodCardExtended extends StatelessWidget {
  final String nomPlat;
  final String imagePlat;
  final String nomResto;
  final String imageResto;
  final String descriptionResto;
  final String descriptionPlat;
  final FoodeeItem foodeeItem;
  final double prix;

  const FoodCardExtended({
    Key? key,
    required this.nomPlat,
    required this.nomResto,
    required this.descriptionPlat,
    required this.descriptionResto,
    required this.foodeeItem,
    this.imagePlat = 'assets/images/menu_card.png',
    this.imageResto = 'assets/images/pakopako_image.png',
    required this.prix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenu de la carte
        Container(
          color: MaterialTheme.lightScheme().surfaceContainerLowest,
          margin: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image collée en haut avec bord arrondi et ombre
              Stack(
                children: [
                  Container(
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
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(4), // Coins inférieurs arrondis
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imagePlat,
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: double.infinity,
                            height: 320,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  // Bouton retour
                  Positioned(
                    top: 32,
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
              ),
              // Contenu de la carte
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomPlat,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: MaterialTheme.lightScheme().onSurface,
                        decoration: TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis, // S'assurer que le texte ne déborde pas
                      maxLines: 1, // Limiter à une ligne
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // Image à gauche
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0), // Image arrondie
                          child: CachedNetworkImage(
                            imageUrl: imageResto,
                            height: 40.0,
                            width: 40.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 8.0), // Espace entre l'image et le texte
                        // Texte à droite
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nom du restaurant en haut
                              Row(
                                children: [
                                  Text(
                                    nomResto,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: MaterialTheme.lightScheme().onSurface,
                                      decoration: TextDecoration.none,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Si le texte est trop long
                                    maxLines: 1, // Limiter à une ligne
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    size: 16,
                                    Icons.check_circle,
                                    color: MaterialTheme.lightScheme().primary,
                                  )
                                ],
                              ),
                              const SizedBox(height: 4.0), // Espacement entre le nom et la description
                              // Description en bas
                              Text(
                                descriptionResto,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: MaterialTheme.lightScheme().secondary,
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 2, // Limiter la description à deux lignes
                                overflow: TextOverflow.ellipsis, // Gestion du texte trop long
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    HorizontalLine(color: MaterialTheme.lightScheme().outlineVariant),
                    SizedBox(height: 12),
                    Text(
                      'Description :',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: MaterialTheme.lightScheme().onSurface,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    Text(
                      descriptionPlat,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: MaterialTheme.lightScheme().onSurfaceVariant,
                        letterSpacing: 0.5,
                        height: 1.33, 
                        decoration: TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis, // Eviter le débordement du texte
                      maxLines: 3, // Limiter à 3 lignes si nécessaire
                    ),
                    Row(
                      children: [
                        Text(
                          'Prix ',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            color: MaterialTheme.lightScheme().onSurface,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${prix.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: MaterialTheme.lightScheme().onSurfaceVariant,
                            letterSpacing: 0.5,
                            height: 1.33, 
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis, // Eviter le débordement du texte
                          maxLines: 3, // Limiter à 3 lignes si nécessaire
                    ) ] ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Box collé au bottom avec bordures arrondies et ombre
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 132,
            // decoration: BoxDecoration(
            //   color: MaterialTheme.lightScheme().surfaceContainerLow,
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(12),
            //     topRight: Radius.circular(12),
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Color.fromARGB(36, 0, 0, 0),
            //       blurRadius: 4,
            //       offset: Offset(0, -1),
            //     ),
            //   ],
            // ),
            child: Column(
              children: [
                // Drag Handle en haut
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Container(
                //     width: 32,
                //     height: 4,
                //     decoration: BoxDecoration(
                //       color: MaterialTheme.lightScheme().outlineVariant,
                //       borderRadius: BorderRadius.circular(3),
                //     ),
                //   ),
                // ),
                Spacer(),
                // Bouton personnalisé en bas
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:16, left: 16.0, right:16),
                      child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                      CustomButton(
                        label: "Visiter le resto", 
                        color: MaterialTheme.lightScheme().primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 600), // Adjust the duration here
                              pageBuilder: (context, animation, secondaryAnimation) => RestaurantScreen(f: foodeeItem),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      ],)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}