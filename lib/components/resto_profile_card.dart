import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rider_register/theme/theme_helper.dart';
import '../theme.dart';

class RestoProfileCard extends StatelessWidget {
  final String nomResto;
  final String photoProfil;
  final double? star;
  final bool ouvert;
  final String description;

  const RestoProfileCard({
    required this.nomResto,
    // this.photoProfil = 'assets/images/pakopako_image.png',
    this.photoProfil = 'assets/images/pakopako_image.png',
    this.star = 0,
    required this.ouvert,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ColorManager customColor = ColorManager(context);

    return Container(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Couverture en haut
          
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Photo de profil au milieu à gauche
              Positioned(
                top: -32.0,
                left: 12.0,
                child: Container(
                  padding: const EdgeInsets.all(0.0), // Épaisseur de la bordure
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 4.0, // Épaisseur de la bordure
                      color: scheme.surfaceContainerLowest, // Couleur de la bordure
                    ),
                    color: Colors.white, // Couleur de la bordure (ici blanc)
                    shape: BoxShape.circle, // Forme circulaire
                  ),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(photoProfil),
                    radius: 40.0, // Rayon du cercle interne
                    backgroundColor: colorScheme.surface,
                  ),
                ),
              ),
              // Texte sous la bannière
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded( 
                          child:Container(
                            alignment: Alignment.centerLeft,
                            height: 26,
                            child: FittedBox(
                              fit: BoxFit.scaleDown, // Shrinks text to fit within the container
                              child: Row(
                                children: [
                                  Text(
                                    nomResto,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      decoration: TextDecoration.none,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.check_circle, // Icône de vérification
                                    color: customColor.getColor("primaryFixedDim"), // Couleur de l'icône
                                    size: 20, // Taille de l'icône
                                  ),
                                ]
                              )
                            )
                          )
                        ),
                        // Row(
                        //   children: [

                        
                        SizedBox(width: MediaQuery.of(context).size.width/24),
                        // État ouvert/fermé
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: ouvert
                                ? colorScheme
                                    .primaryContainer
                                    .withOpacity(0.85)
                                : colorScheme.error.withOpacity(0.2),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20), // Rayon en haut à gauche
                              topRight: Radius.circular(0),  // Pas de rayon en haut à droite
                              bottomLeft: Radius.circular(20), // Rayon en bas à gauche
                              bottomRight: Radius.circular(0), // Pas de rayon en bas à droite
                            ), 
                          ),
                          // child: 
                          // Expanded( 
                            child:
                              Text(
                                ouvert ? "Ouvert" : "Fermé",
                                style: TextStyle(
                                  color: ouvert
                                      ? colorScheme
                                          .onPrimaryContainer
                                      : colorScheme.error,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.none,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                          // ),
                        ],
                    )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
          // Description sous le texte principal
          Padding(
            padding: const EdgeInsets.only(top:2, left: 100.0, right: 12),
            child: Text(
              description,
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                height: 1.33,
                decoration: TextDecoration.none,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
