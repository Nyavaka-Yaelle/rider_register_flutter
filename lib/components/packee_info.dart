import 'package:flutter/material.dart';
import '../theme.dart';

class PackeeInfo extends StatelessWidget {
  final VoidCallback? onActionTap; // Callback pour l'action

  const PackeeInfo({
    Key? key,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.0025),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/packee.png',
            height: 136.0,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12.0),
        // Titre principal
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Packee',
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
            '“Besoin de récupérer un colis ?\nc’est un clic et c’est réglé.”',
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
            'Avec Packee, vos colis sont entre de bonnes mains : \nrécupération rapide et suivi simplifié.',
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
