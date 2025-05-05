import 'package:flutter/material.dart';
import './resto_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/models/restaurant.dart';
import 'package:rider_register/repository/restaurant_repository.dart';
import 'package:rider_register/screens/restaurant_screen.dart';
import 'package:rider_register/widgets/sized_box_height.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../theme/theme_helper.dart';

class RestoCards extends StatefulWidget {
  final String? searchQuery; // Make searchQuery optional

  const RestoCards({this.searchQuery});

  @override
  _RestoCardsState createState() => _RestoCardsState();
}

class _RestoCardsState extends State<RestoCards> {
  List<Restaurant> _restaurants = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    try {
      print(" context init " +
          context.read<DeliveryData>().isFetching.toString());
      context.read<DeliveryData>().setIsFetching(true);
      Location location = Location();
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.granted) {
        var currentPosition = await Location().getLocation();

        context.read<DeliveryData>().setDepartLocation(
              LatLng(
                currentPosition.latitude!,
                currentPosition.longitude!,
              ),
            );

        if (context.read<DeliveryData>().departAddress == null) {
          final apiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
          final url =
              'https://maps.googleapis.com/maps/api/geocode/json?latlng=${context.read<DeliveryData>().departLocation!.latitude},${context.read<DeliveryData>().departLocation!.longitude}&key=$apiKey';
          final response = await http.get(Uri.parse(url));
          final Map<String, dynamic> data = json.decode(response.body);
          final originAddresses = data['results'][0]['formatted_address'];
          context.read<DeliveryData>().setDepartAddress(originAddresses);
        }
        await _fetchRestaurants();
        context.read<DeliveryData>().setIsFetching(false);
      } else {
        await location.requestPermission();
      }
    } catch (e) {
      print("ERROR IN RESTAURANTS SCREEN 62");
      print(e.toString());
      context.read<DeliveryData>().setIsFetching(false);

      print(" context " + context.read<DeliveryData>().isFetching.toString());
      Navigator.of(context).pop();
      rethrow;
    } finally {
      context.read<DeliveryData>().setIsFetching(false);
    }
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      isLoading = true;
    });
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      await _fetchRestaurantsByQuery(widget.searchQuery!);
    } else {
      await _fetchDefaultRestaurants();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchDefaultRestaurants() async {
    var v = await getRestaurantsDistancedOrigins(
        "${context.read<DeliveryData>().departLocation!.latitude},${context.read<DeliveryData>().departLocation!.longitude}");
    setState(() {
      _restaurants = v;
    });
  }

  Future<void> _fetchRestaurantsByQuery(String query) async {
    var v = await searchRestaurants(query);
    setState(() {
      _restaurants = v;
    });
  }

  @override
  void didUpdateWidget(RestoCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchRestaurants(); // Fetch new items when the search query changes
    }
  }

  @override
  Widget build(BuildContext context) {
     if (_restaurants.isEmpty) {
      return isLoading
          ? _buildSkeletonCards()
          : Container(
        height: MediaQuery.of(context).size.height / 2,
        child:Center(
        child: Text(
          'Aucun élément trouvé',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ));
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
                children: _restaurants.map((restaurant) {
                  return RestoCard(
                    nomResto: restaurant.name,
                    couvertureImage: restaurant.bannerPicture,
                    photoProfil: restaurant.profilePicture,
                    ouvert: restaurant.isOpen,
                    description: restaurant.address,
                    star: restaurant.stars,
                    onTap: () {
                      context.read<DeliveryData>().setOrderingRestaurant(restaurant);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 600), // Adjust the duration here
                          pageBuilder: (context, animation, secondaryAnimation) => RestaurantScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildSkeletonCards() {
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
}