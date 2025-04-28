import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List<Restaurant> _restaurants = [];

  Future<void> init() async {
    try {
      print(" context init " +
          context.read<DeliveryData>().isFetching.toString());
      context.read<DeliveryData>().setIsFetching(true);
      Location location = Location();
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.granted) {
        // TODO uncomment dynamic geolocation
        // if (context.read<DeliveryData>().departLocation == null) {
        // var currentPosition = await Location().getLocation();
        // context.read<DeliveryData>().setDepartLocation(
        //       new LatLng(
        //         currentPosition.latitude!,
        //         currentPosition.longitude!,
        //       ),
        //     );
        // }
        // TODO comment static geolocation
        var currentPosition = await Location().getLocation();

        context.read<DeliveryData>().setDepartLocation(
              new LatLng(
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
        var v = await getRestaurantsDistancedOrigins(
            "${context.read<DeliveryData>().departLocation!.latitude},${context.read<DeliveryData>().departLocation!.longitude}");
        setState(() {
          _restaurants = v;
        });

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

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restaurants.isEmpty) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Skeleton(
        isLoading: context.read<DeliveryData>().isFetching,
        skeleton: SkeletonListView(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBoxHeight(height: "md"),
              const WidgetPosition(),
              // const SizedBoxHeight(height: "md"),
              // const WidgetFoodSearchBox(),
              const SizedBoxHeight(height: "sm"),
              Expanded(
                child: ListView.separated(
                  itemCount: _restaurants.length,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBoxHeight(height: "md"),
                  itemBuilder: (BuildContext context, int index) {
                    return WidgetRestaurantCard(
                      restaurant: _restaurants[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetRestaurantCard extends StatefulWidget {
  final Restaurant restaurant;

  const WidgetRestaurantCard({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<WidgetRestaurantCard> createState() => _WidgetRestaurantCardState();
}

class _WidgetRestaurantCardState extends State<WidgetRestaurantCard> {
  Future<void> goToRestaurantScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantScreen(),
      ),
    );
  }

  Future<void> init() async {
    setState(() {});
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: InkWell(
          onTap: () {
            goToRestaurantScreen();

            context
                .read<DeliveryData>()
                .setOrderingRestaurant(widget.restaurant);
          },
          child: Row(
            children: [
              WidgetRestaurantProfilePicture(
                restaurant: widget.restaurant,
              ),
              WidgetRestaurantDescription(
                restaurant: widget.restaurant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetRestaurantDescription extends StatelessWidget {
  final Restaurant restaurant;
  const WidgetRestaurantDescription({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetRestaurantDescriptionHeader(restaurant: restaurant),
        const SizedBoxHeight(height: "xsm"),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 1,
          child: const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        const SizedBoxHeight(height: "xsm"),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: WidgetRestaurantDescriptionBody(
            restaurant: restaurant,
          ),
        ),
      ],
    );
  }
}

class WidgetRestaurantDescriptionBody extends StatefulWidget {
  final Restaurant restaurant;
  const WidgetRestaurantDescriptionBody({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<WidgetRestaurantDescriptionBody> createState() =>
      _WidgetRestaurantDescriptionBodyState();
}

class _WidgetRestaurantDescriptionBodyState
    extends State<WidgetRestaurantDescriptionBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.restaurant.distanceFromOrigin == null
              ? ""
              : "${widget.restaurant.distanceFromOrigin} en ${widget.restaurant.durationFromOrigin}",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          widget.restaurant.address,
          style: TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }
}

class WidgetRestaurantDescriptionHeader extends StatelessWidget {
  final Restaurant restaurant;
  const WidgetRestaurantDescriptionHeader({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(restaurant.name),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.12,
              child: Row(
                children: [
                  Text(
                    Restaurant.getDollardSymbole(
                      restaurant.mostExpensivePrice,
                    ),
                    style: TextStyle(color: Colors.teal[300]),
                  ),
                  Text(
                    Restaurant.getDollardSymboleInverse(
                      restaurant.mostExpensivePrice,
                    ),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.58,
              child: WidgetFoodStar(restaurant: restaurant),
            ),
          ],
        ),
      ],
    );
  }
}

class WidgetRestaurantProfilePicture extends StatelessWidget {
  final Restaurant restaurant;
  const WidgetRestaurantProfilePicture({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            height: MediaQuery.of(context).size.width * 0.18,
          ),
          Positioned(
            top: 2,
            left: 2,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
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
                    restaurant.bannerPicture,
                  ),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: scheme.shadow,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    restaurant.profilePicture,
                  ),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetFoodStar extends StatelessWidget {
  final Restaurant restaurant;
  const WidgetFoodStar({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            restaurant.restaurantFoodType!.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.right,
          ),
        ),
        Icon(
          Icons.star_rounded,
          color: Colors.amber[500],
        ),
        Text(
          "${restaurant.stars}",
        ),
      ],
    );
  }
}

class WidgetFoodSearchBox extends StatelessWidget {
  const WidgetFoodSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02),
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Je veux manger quoi ajourd'hui",
        ),
      ),
    );
  }
}

class WidgetPosition extends StatelessWidget {
  const WidgetPosition({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(
              Icons.location_on,
              color: Colors.red,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ma position"),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  context.read<DeliveryData>().departAddress ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
