import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rider_register/models/menu_item.dart';
import 'package:rider_register/screens/restaurant_screen.dart';
import 'package:skeletons/skeletons.dart';
import '../theme.dart';
import 'package:rider_register/repository/restaurant_repository.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';

class FoodCard extends StatelessWidget {
  final String nomPlat;
  final String nomResto;
  final String imagePlat;
  final String? imageResto;
  final double? star;
  final double prix;
  final VoidCallback? onPressed;
  final FoodeeItem foodeeItem;

  const FoodCard({
    required this.nomPlat,
    required this.nomResto,
    this.imagePlat = 'assets/images/menu_image.png',
    this.imageResto,// = 'assets/images/pakopako_image.png',
    this.star = 0,
    required this.prix,
    this.onPressed,
    required this.foodeeItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPressed,
      child: Container(
        width: (MediaQuery.of(context).size.width /
                (Device.get().isTablet ? 3 : 2)) -
            12 -
            3,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            GestureDetector(
              onTap: onPressed,
              child: ClipRRect(
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
            )),
            const SizedBox(height: 8.0),
            // Nom du plat
            GestureDetector(
              onTap: onPressed,
              child:Text(
              nomPlat,
              style: TextStyle(
                color: MaterialTheme.lightScheme().onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            const SizedBox(height: 4.0),
            // Nom du restaurant + étoiles
            Row(
              children: [
                Expanded(
                  child: 
                  GestureDetector(
                    onTap: () {

                       getRestaurantByReference(foodeeItem.restaurantId).then(
                    (value) {
                      print(value!.name);
   
                      if(context.read<DeliveryData>().orderingRestaurant!=null)  {
                        context.read<DeliveryData>().setCartFoodeeItems([]);
                      } //??
                      context.read<DeliveryData>().setOrderingRestaurant(value!);
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
                    }
                  );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: imageResto!=null?
                         CachedNetworkImage(
                            imageUrl: imageResto!,
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 20,
                                height: 20.0,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ):
                          Image.asset(
                          "assets/images/foodee_service.png",
                          height: 20.0,
                          width: 20.0,
                          fit: BoxFit.cover,
                        )
                        ,
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
                  )),
                ),
                /*Row(
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
                ),*/
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
                    backgroundColor: Colors.transparent,
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
