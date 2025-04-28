import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';
import '../theme.dart';

class FoodCard extends StatelessWidget {
  final String nomPlat;
  final String nomResto;
  final String imagePlat;
  final String imageResto;
  final double? star;
  final double prix;
  final VoidCallback? onPressed;

  const FoodCard({
    required this.nomPlat,
    required this.nomResto,
    this.imagePlat = 'assets/images/menu_image.png',
    this.imageResto = 'assets/images/pakopako_image.png',
    this.star = 0,
    required this.prix,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: (MediaQuery.of(context).size.width /
                (Device.get().isTablet ? 3 : 2)) -
            12 -
            3,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                imageUrl: imagePlat,
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
            ),
            const SizedBox(height: 8.0),
            // Nom du plat
            Text(
              nomPlat,
              style: TextStyle(
                color: MaterialTheme.lightScheme().onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            // Nom du restaurant + étoiles
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          imageResto,
                          height: 20.0,
                          width: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nomResto,
                          style: TextStyle(
                            color: MaterialTheme.lightScheme().onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star_rate_rounded,
                        size: 20.0, color: Colors.red),
                    SizedBox(width: 1.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        star.toString(),
                        style: TextStyle(
                          color: MaterialTheme.lightScheme().onSurface,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${prix.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]} ")} Ar",
                    style: TextStyle(
                      color: MaterialTheme.lightScheme().onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: SvgPicture.asset(
                    'assets/images/commander.svg',
                    width: 26.0,
                    fit: BoxFit.contain,
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
