import 'package:flutter/material.dart';
import 'package:rider_register/theme/theme_helper.dart';
import '../theme.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch; // Callback pour réagir aux changements de texte

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        height: 48, // Hauteur de la barre de recherche
        decoration: BoxDecoration(
          color: MaterialTheme.lightScheme().surfaceContainer, // Couleur gris clair
          borderRadius: BorderRadius.circular(100), // Bordure arrondie avec un rayon de 100
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12), // Padding à gauche et à droite
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
                    controller: _controller,
                    style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant, // Couleur de l'icône
                    decoration: InputDecoration(
                      hintText: 'Un plat en tête ?',
                      hintStyle: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                      border: InputBorder.none, // Aucun bord autour du champ de texte
                    ),
                    onChanged: widget.onSearch, // Call the callback when the query changes
                  ),
                ),
              ),
              // Utilisation d'un ValueListenableBuilder pour réagir au changement du texte
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return value.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();// Efface le texte
                            widget.onSearch("");  // Appelle la fonction de recherche avec une chaîne vide
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.close_rounded, // Icône de fermeture
                                size: 18,
                                color: MaterialTheme.lightScheme().onSurfaceVariant, // Couleur de l'icône
                              )),
                        )
                      : SizedBox.shrink(); // Si le champ est vide, ne rien afficher
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
