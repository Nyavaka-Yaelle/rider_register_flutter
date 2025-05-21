import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../screens/page_info.dart';
import '../theme.dart';
import '../screens/restaurants_screen.dart';
import '../screens/destination2_screen.dart';
import '../repository/user_repository.dart';
import '../screens/foodee_home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rider_register/screens/placearrive_screen.dart';

class ServiceCard extends StatelessWidget {
  final VoidCallback? onActionTap; // Callback pour l'action
  final int idService;
  final String image;
  final String label;
  final String type; // Add the type parameter
  final UserRepository userRepository = UserRepository(); // Add userRepository

  ServiceCard({
    Key? key,
    this.image = 'ridee_service',
    this.label = 'Ridee',
    this.onActionTap,
    this.idService = 0,
    required this.type, // Add the type parameter
  }) : super(key: key);

  void onTapRow(BuildContext context, String type) {
    String? currentid = userRepository.getCurrentUser()?.uid;
    print("type $type");

    Widget destination;
    if (type == "foodee") {
      destination =
          currentid != null ? FoodeeHomeScreen() : PageInfo(idService: 2);
    } else if (type == "caree") {
      destination = currentid != null
          ? Destination2Screen(type: type)
          : PageInfo(idService: 1);
    } else if (type == "packee") {
      destination = currentid != null
          ? Destination2Screen(type: type)
          : PageInfo(idService: 3);
    } else if (type == "ridee") {
      destination = currentid != null
          // ? Destination2Screen(type: type)
          ? PlacearriveScreen(isDepart:false, type: type)
          : PageInfo(idService: 0);
    } else {
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600), // Adjust the duration here
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        onTapRow(context, type); // Call the onTapRow function
      },
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 4) - 20, // Largeur du container
                height: 62,
                clipBehavior: Clip.none,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: MaterialTheme.lightScheme().onSurfaceVariant, // Définit la couleur de la bordure
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)), // Bordure arrondie
                ),
                // child: Align(
                //   alignment: Alignment.center,
                //   child: Image.asset(
                //     'assets/images/' + image + '.png',
                //     height: label == 'Ridee' ? 30.0 : 48.0,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/' + image + '.svg', // Remplacez .png par .svg
                      // height:  label == 'Caree' ? 26.0 : 30.0,
                      fit: BoxFit.contain,
                    )),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MaterialTheme.lightScheme().onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
