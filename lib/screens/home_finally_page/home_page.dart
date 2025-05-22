import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/models/pub.dart';
import 'package:rider_register/repository/pub_repository.dart';
import 'package:rider_register/screens/destination1_screen.dart';
import 'package:rider_register/screens/destination2_screen.dart';
import 'package:rider_register/screens/restaurants_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:rider_register/widgets/modal/custom_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/components/services_card.dart';
//animation import
import 'package:animations/animations.dart';
//Foodee import
import 'package:rider_register/repository/menu_item_repository.dart';
import 'package:rider_register/models/menu_item.dart';
import 'package:rider_register/screens/restaurant_screen.dart';
import 'package:rider_register/repository/restaurant_repository.dart';
import 'package:rider_register/screens/food_card_extended.dart';
import 'package:rider_register/components/food_card.dart';
import 'package:skeletons/skeletons.dart';

import '../../main.dart';
import '../../repository/user_repository.dart';
import '../../services/api_service.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_search_view.dart';
import 'widgets/food_item_widget.dart'; // ignore_for_file: must_be_immutable
import 'package:rider_register/screens/page_info.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PubRepository pubRepository = PubRepository();
  List<FoodeeItem> _randomItems = [];
  String? currentid;
  final UserRepository userRepository = UserRepository();
  LocationData? _currentPosition;
  ApiService apiService = ApiService();
  List<String> imageUrls = [];
  List<String> linkUrls = [];
  Pub? p;
  bool isLoading = true; // Add a loading state
  bool isFetching = false; // Add a fetching state for onTapImgUserImage

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      p = await pubRepository.getPub();
      imageUrls.add(p!.pub1!);
      imageUrls.add(p!.pub2!);
      // imageUrls.add(p!.pub3!);

      linkUrls.add(p!.link1!);
      linkUrls.add(p!.link2!);
      // linkUrls.add(p!.link3!);

      _getCurrentPosition();
    });
    super.initState();
    _fetchRandomItems();
  }

  Future<void> _fetchRandomItems() async {
    final items = await getXRandomItems(Device.get().isTablet ? 3 : 4);
    setState(() {
      _randomItems = items;
      isLoading = false; // Set loading to false when data is fetched
    });
  }

  void _getCurrentPosition() async {
    _currentPosition = await Location().getLocation();
    print(
        "camera moved to ${_currentPosition!.latitude} ${_currentPosition!.longitude}");
    setState(() {
      context.read<DeliveryData>().setDepartLocationFoodee(
            LatLng(
              _currentPosition!.latitude!.toDouble(),
              _currentPosition!.longitude!.toDouble(),
            ),
          );
    });
    await apiService
        .getFormattedAddresses(LatLng(
      _currentPosition!.latitude!.toDouble(),
      _currentPosition!.longitude!.toDouble(),
    ))
        .then((value) {
      setState(() {
        context.read<DeliveryData>().setDepartAddressFoodee(value);
      });
    });
  }

  TextEditingController searchController = TextEditingController();

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmation'),
            content: Text('Vous voulez vraiment fermer l\'application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Non'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Oui'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    void isLaunchUrl(String urlString) async {
      printanah('message');
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              // color: appTheme.green5001,
              color: scheme.surfaceContainerLowest,
              child: Column(
                children: [
                  // CustomSearchView(
                  //   controller: searchController,
                  //   hintText: "Quoi de bon pour aujourd’hui?",
                  // ),
                  Container(
                    decoration: AppDecoration.fillGray50.copyWith(
                      // borderRadius: BorderRadiusStyle.customBorderTL24,
                      color: scheme.surfaceContainerLowest,
                    ),

                    child: Column(

                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 24),
                        ServicesCard(),
                        Divider(),
                        Section(name: "Pour vous"),
                        SizedBox(height: 9.h),
                        isLoading
                            ? _buildSkeletonCard(context)
                            : _buildCard(context), // Show skeleton if loading
                        SizedBox(height: 12.h),
                        Section(name: "Promotions"),
                        SizedBox(height: 9.h),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(linkUrls.length, (index) {
                            return Container(
                              width: (MediaQuery.of(context).size.width /
                                      (Device.get().isTablet ? 2 : 1)) -
                                  12 -
                                  3,
                              child: InkWell(
                                onTap: () => isLaunchUrl(linkUrls[index]),
                                splashColor: Colors.white10,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrls[index],
                                ),
                              ),
                            );
                          }),
                        ),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   itemCount: imageUrls.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: InkWell(
                        //         onTap: () => isLaunchUrl(linkUrls[index]),
                        //         splashColor: Colors.white10,
                        //         child: CachedNetworkImage(
                        //           imageUrl: imageUrls[index],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFetching)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final item in ["Ridee", "Caree", "Foodee", "Packee"])
            _careeItem(
              context,
              item,
              imageMap[item] ?? "",
              onTap: () => onTapRow(context, item.toLowerCase()),
            ),
        ],
      ),
    );
  }

  final imageMap = {
    "Ridee": ImageConstant.imgRideeCircle,
    "Caree": ImageConstant.imgCareeCircle,
    "Foodee": ImageConstant.imgFoodeeCircle,
    "Packee": ImageConstant.imgPakceeCircle,
  };

  Widget _careeItem(
    BuildContext context,
    String caree,
    String imagePath, {
    Function()? onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.v, vertical: 2.h),
        child: _caree(
          context,
          caree: caree,
          imagePath: imagePath,
          onTapRowcaree: onTap,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List.generate(_randomItems.length, (index) {
        final item = _randomItems[index];

        return FoodCard(
          foodeeItem: item,
          nomPlat: item.name,
          nomResto: item.restaurantName ?? "Restaurant",
          // nomResto: item.description,
          imageResto: item.imageResto ,
          prix: item.price,
          imagePlat: item.image,
          star: 4.5,
          onPressed: () {
            onTapImgUserImage(context, item);
          },
        );
      }),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 189.v,
          crossAxisCount: 2,
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 18.h,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: _randomItems.length,
        itemBuilder: (context, index) {
          final item = _randomItems[index];

          return FoodCard(
            foodeeItem: item,
            nomPlat: item.name,
            nomResto: item
                .description, // Assuming you have restaurantName in FoodeeItem
            prix: item.price,
            imagePlat: item.image,
            star: 4.5, // Assuming you have rating in FoodeeItem
            onPressed: () {
              onTapImgUserImage(context, item);
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 189.v,
          crossAxisCount: 2,
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 18.h,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4, // Number of skeleton items to show
        itemBuilder: (context, index) {
          return SkeletonItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
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
                // Nom du plat
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                    width: 100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 4.0),
                // Nom du restaurant + étoiles
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 20.0,
                          height: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 14,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        SizedBox(width: 1.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 12,
                              width: 20,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Prix + Bouton Commander
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16,
                          width: 50,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 26.0,
                        height: 26.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Common widget
  Widget _caree(
    BuildContext context, {
    required String caree,
    required String imagePath,
    Function? onTapRowcaree,
  }) {
    return GestureDetector(
        onTap: () {
          onTapRowcaree?.call();
        },
        child: Container(
          height: 24,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: scheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomImageView(
                imagePath: imagePath,
                height: 20.adaptSize,
                width: 20.adaptSize,
                radius: BorderRadius.circular(
                  10.h,
                ),
              ),
              Text(
                caree,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: appTheme.gray700,
                ),
              ),
            ],
          ),
        ));
  }

  /// Navigates to the rideeServicesScreen when the action is triggered.
  void onTapRow(BuildContext context, String type) {
    currentid = userRepository.getCurrentUser()?.uid;

    if (type == "foodee") {
      if (currentid != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RestaurantsScreen()),
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageInfo(idService: 1)),
          );
        });
      }
    } else {
      if (currentid != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Destination2Screen(type: type)),
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageInfo(idService: 0)),
          );
        });
      }
    }
  }

  /// Navigates to the frameFourScreen when the action is triggered.
  onTapUserprofile(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.frameFourScreen);
  }

  /// Navigates to the frameThreeScreen when the action is triggered.
  onTapImgUserImage(BuildContext context, FoodeeItem item) {
    setState(() {
      isFetching = true;
    });

    currentid = userRepository.getCurrentUser()?.uid;
    if (currentid != null) {
      getRestaurantByReference(item.restaurantId).then((value) {
        setState(() {
          isFetching = false;
        });

        print(value!.name);
         if(context.read<DeliveryData>().orderingRestaurant!=null)  {
            context.read<DeliveryData>().setCartFoodeeItems([]);
          }
        context.read<DeliveryData>().setOrderingRestaurant(value!);

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration:
                Duration(milliseconds: 600), // Adjust the duration here
            pageBuilder: (context, animation, secondaryAnimation) =>
                FoodCardExtended(
              foodeeItem: item,
              nomPlat: item.name,
              nomResto: value.name,
              descriptionPlat: item.description,
              descriptionResto: value.name,
              imagePlat: item.image,
              imageResto: value.profilePicture,
              prix: item.price,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isFetching = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageInfo(idService: 2)),
        );
      });
    }
  }
}

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 16.h),
        child: Text(
          name,
          style: CustomTextStyles.titleSmallGray90001,
        ),
      ),
    );
  }
}
