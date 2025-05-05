import 'package:flutter/material.dart';
import '../theme.dart';
class AddressOnYourCard extends StatelessWidget {
  final String adresse;
  // final String heure;
  // final String nomLieu;

  const AddressOnYourCard({
    required this.adresse,
    // required this.heure,
    // required this.nomLieu,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ColorManager customColor = ColorManager(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     blurRadius: 8.0,
        //     spreadRadius: 2.0,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Première ligne: icône de localisation, adresse et icône d'édition
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 24,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Votre position",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        adresse,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          height: 1.33,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.fastfood_rounded,
                size: 32,
                color: colorScheme.error,
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}
