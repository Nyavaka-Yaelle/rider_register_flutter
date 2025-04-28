import 'package:flutter/material.dart';
import '../theme.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final VoidCallback?
      onPressed; // `VoidCallback?` pour accepter `null` si le bouton est désactivé
  final Color color;
  final bool isDisabled;
  final bool outline;
  final IconData? icon;

  // Constructeur
  const CustomIconButton({
    required this.label,
    required this.onPressed,
    required this.color,
    this.isDisabled = false,
    this.outline = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (outline) {
      // Utilisation d'OutlinedButton pour un fond transparent et un contour
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          fixedSize: Size(double.infinity, 24),
          side: BorderSide(
            color: isDisabled
                ? MaterialTheme.lightScheme().onPrimaryContainer.withOpacity(0.5)
                : MaterialTheme.lightScheme().outline, // Couleur du contour
            width: 1.0, // Épaisseur du contour
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Arrondi du bouton
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 12), // Espacement du contenu
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDisabled
                    ? MaterialTheme.lightScheme().onPrimaryContainer.withOpacity(0.5)
                    : MaterialTheme.lightScheme().onPrimaryContainer, // Couleur du texte
                fontSize: 14,
              ),
            ),
            Icon(
              // Icons.arrow_right_alt_rounded,
              icon,
              color: MaterialTheme.lightScheme().onPrimaryContainer,
              size: 20.0,
            ),
          ])
      );
    } else {
      // Utilisation d'ElevatedButton pour un fond rempli
      return ElevatedButton(
      
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? MaterialTheme.lightScheme().onPrimaryContainer.withOpacity(0.12)
              : color.withOpacity(0.75), // Couleur du fond
          fixedSize: Size(double.infinity, 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDisabled
                    ? MaterialTheme.lightScheme().onPrimaryContainer.withOpacity(0.5)
                    : MaterialTheme.lightScheme().onPrimaryContainer, // Couleur du texte
                fontSize: 14,
              ),
            ),
            Icon(
              // Icons.arrow_right_alt_rounded,
              icon,
              color: MaterialTheme.lightScheme().onPrimaryContainer,
              size: 20.0,
            ),
          ])
      );
    }
  }
}
