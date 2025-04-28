import 'package:flutter/material.dart';
import '../theme.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        height: 48, // Hauteur de la barre de recherche
        decoration: BoxDecoration(
          color: MaterialTheme.lightScheme().surfaceContainerHigh, // Couleur gris clair
          borderRadius: BorderRadius.circular(100), // Bordure arrondie avec un rayon de 100
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12), // Padding à gauche et à droite
          child: Row(
            children: [
              Icon(
                Icons.search, // Icône de loupe
                color: MaterialTheme.lightScheme().onSurfaceVariant, // Couleur de l'icône
              ),
              SizedBox(width: 12), 
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: TextField(
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant, // Couleur de l'icône
                    decoration: InputDecoration(
                      hintText: 'Un plat en tête ?',
                      border: InputBorder.none, // Aucun bord autour du champ de texte
                    ),
                    onChanged: onSearch, // Call the callback when the query changes
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}