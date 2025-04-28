import 'package:flutter/material.dart';
import '../theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback?
      onPressed; // `VoidCallback?` pour accepter `null` si le bouton est désactivé
  final Color color;
  final bool isDisabled;
  final bool outline;

  // Constructeur
  const CustomButton({
    required this.label,
    required this.onPressed,
    required this.color,
    this.isDisabled = false,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outline) {
      // Utilisation d'OutlinedButton pour un fond transparent et un contour
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          fixedSize: Size(double.infinity, 40),
          side: BorderSide(
            color: isDisabled
                ? MaterialTheme.lightScheme().onSurface.withOpacity(0.5)
                : MaterialTheme.lightScheme().outline, // Couleur du contour
            width: 1.0, // Épaisseur du contour
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Arrondi du bouton
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 20), // Espacement du contenu
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDisabled
                ? MaterialTheme.lightScheme().onSurface.withOpacity(0.5)
                : MaterialTheme.lightScheme().primary, // Couleur du texte
            fontSize: 16,
          ),
        ),
      );
    } else {
      // Utilisation d'ElevatedButton pour un fond rempli
      return ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? MaterialTheme.lightScheme().onSurface.withOpacity(0.12)
              : color, // Couleur du fond
          fixedSize: Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDisabled
                ? MaterialTheme.lightScheme().onSurface.withOpacity(0.5)
                : Colors.white, // Couleur du texte
            fontSize: 16,
          ),
        ),
      );
    }
  }
}
