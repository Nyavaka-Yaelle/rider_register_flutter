import 'package:flutter/material.dart';
import '../theme.dart';

class RideeInfo extends StatelessWidget {
  final VoidCallback? onActionTap; // Callback pour l'action

  const RideeInfo({
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
            'assets/images/ridee.png',
            height: 136.0,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12.0),
        // Titre principal
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Ridee',
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
            '“Des trajets sûrs, simples et un paiement \nqui s\'adapte à votre quotidien.”',
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
            'Vos itinéraires, votre rythme : avec Ridee, gérez des trajets\n multipoints et réservez un taxi-moto en un clin d’œil.',
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
