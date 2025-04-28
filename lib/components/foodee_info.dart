import 'package:flutter/material.dart';
import '../theme.dart';

class FoodeeInfo extends StatelessWidget {
  final VoidCallback? onActionTap; // Callback pour l'action

  const FoodeeInfo({
    Key? key,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/foodee.png',
            height: 136.0,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12.0),
        // Titre principal
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Foodee',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: MaterialTheme.lightScheme().secondary,
            ),
          ),
        ),
        // Slogan
        SizedBox(height: 12),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            '“Choisissez, commandez, et savourez \nen quelques clics.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: MaterialTheme.lightScheme().onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: 12),
        // Description
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Avec Foodee, commandez vos plats préférés et faites-les livrer en toute simplicité, où que vous soyez.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: MaterialTheme.lightScheme().tertiary,
            ),
          ),
        ),
      ], // color: MaterialTheme.lightScheme().surfaceContainerLow,
    );
  }
}
