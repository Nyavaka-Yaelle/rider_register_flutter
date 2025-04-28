import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';
import '../theme.dart';

class RestoCard extends StatelessWidget {
  final String nomResto;
  final String couvertureImage;
  final String photoProfil;
  final double? star;
  final bool ouvert;
  final String description;
  final VoidCallback onTap; // Add the onTap callback

  const RestoCard({
    required this.nomResto,
    this.couvertureImage = 'assets/images/banner_picture.png',
    this.photoProfil = 'assets/images/restaurants_profile_picture.png',
    this.star = 0,
    required this.ouvert,
    this.description = '',
    required this.onTap, // Add the onTap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle the tap event
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: MaterialTheme.lightScheme().outlineVariant,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Couverture en haut
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: couvertureImage,
                height: 120.0,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    height: 120.0,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Photo de profil au milieu à gauche
                Positioned(
                  top: -36.0,
                  left: 12.0,
                  child: Container(
                    padding: const EdgeInsets.all(2.0), // Épaisseur de la bordure
                    decoration: BoxDecoration(
                      color: Colors.white, // Couleur de la bordure (ici blanc)
                      shape: BoxShape.circle, // Forme circulaire
                    ),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(photoProfil),
                      radius: 40.0, // Rayon du cercle interne
                      backgroundColor: MaterialTheme.lightScheme().surface,
                    ),
                  ),
                ),
                // Texte sous la bannière
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 96.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nom du restaurant
                          Expanded(
                            child: Text(
                              nomResto,
                              style: TextStyle(
                                color: MaterialTheme.lightScheme().onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rate_rounded,
                                size: 20.0,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                star.toString(),
                                style: TextStyle(
                                  color: MaterialTheme.lightScheme().onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 24),
                          // État ouvert/fermé
                          Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: ouvert
                                  ? MaterialTheme.lightScheme()
                                      .primaryContainer
                                      .withOpacity(0.85)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20), // Rayon en haut à gauche
                                topRight: Radius.circular(0), // Pas de rayon en haut à droite
                                bottomLeft: Radius.circular(20), // Rayon en bas à gauche
                                bottomRight: Radius.circular(0), // Pas de rayon en bas à droite
                              ),
                            ),
                            child: Text(
                              ouvert ? "Ouvert" : "Fermé",
                              style: TextStyle(
                                color: ouvert
                                    ? MaterialTheme.lightScheme()
                                        .onPrimaryContainer
                                    : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Description sous le texte principal
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 96.0, right: 12),
              child: Text(
                description,
                style: TextStyle(
                  color: MaterialTheme.lightScheme().onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  height: 1.33,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}