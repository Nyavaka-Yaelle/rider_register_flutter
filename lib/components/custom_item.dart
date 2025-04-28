import 'package:flutter/material.dart';
import '../theme.dart';

class CustomItem extends StatelessWidget {
  final String label;
  final VoidCallback?
      onPressed; // `VoidCallback?` pour accepter `null` si le bouton est désactivé
  final bool isDisabled;
  final bool outline;
  final bool active;
  final IconData? icon;
  final IconData? activeIcon;

  // Constructeur
  const CustomItem({
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
    this.outline = false,
    this.active = false,
    this.icon,
    this.activeIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (!active) {
      // Utilisation d'OutlinedButton pour un fond transparent et un contour
      return ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: MaterialTheme.lightScheme().surfaceContainerLowest,
          padding: EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: MaterialTheme.lightScheme().onSurfaceVariant,
              size: 20.0,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDisabled
                    ? MaterialTheme.lightScheme().onSurfaceVariant.withOpacity(0.5)
                    : MaterialTheme.lightScheme().onSurfaceVariant, // Couleur du texte
                fontSize: 14,
              ),
            ),
            
          ])
      );
    } else {
      // Utilisation d'ElevatedButton pour un fond rempli
      return ElevatedButton(
      
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? MaterialTheme.lightScheme().secondaryContainer.withOpacity(0.12)
              : MaterialTheme.lightScheme().secondaryContainer.withOpacity(0.75), // Couleur du fond
          fixedSize: Size(double.infinity, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14),
          elevation: 0,
        ),
        child: Row(
          children: [
            Icon(
              activeIcon,
              color: MaterialTheme.lightScheme().onSecondaryContainer,
              size: 20.0,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDisabled
                    ? MaterialTheme.lightScheme().onSecondaryContainer.withOpacity(0.5)
                    : MaterialTheme.lightScheme().onSecondaryContainer, // Couleur du texte
                fontSize: 14,
              ),
            ),
          ])
      );
    }
  }
}
