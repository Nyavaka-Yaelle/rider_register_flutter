import 'package:flutter/material.dart';
import '../theme.dart';

class AddressPosition extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final String imagePath;

  const AddressPosition({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 64, 12, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.outlineVariant,
        //   width: 0,
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône à gauche
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8), // Espacement
          // Texte (Votre position + 3mgh Tana)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: MaterialTheme.lightScheme().onSurfaceVariant,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: MaterialTheme.lightScheme().onSurface,
                ),
                // Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(), // Pousse l'image à droite
          // Image à droite
          Image.asset(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
