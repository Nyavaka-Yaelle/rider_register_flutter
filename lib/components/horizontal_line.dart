import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  final Color color;
  final double thickness;

  const HorizontalLine({
    required this.color,
    this.thickness = 1.0, // Épaisseur par défaut
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      width: double.infinity, // Prend toute la largeur disponible
      color: color, // La couleur de la ligne
      // child: 
      // Expanded(
      //   child: Divider(
      //     color: color,
      //     thickness: thickness,
      //     endIndent: 8.0, // Espace avant le texte
      //   ),
      // ),
    );
  }
}
