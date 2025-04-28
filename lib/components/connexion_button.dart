import 'package:flutter/material.dart';
// import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import './custom_button.dart';
import './horizontal_line.dart';
import '../theme.dart';
import 'package:rider_register/screens/register_screen.dart';
class ConnexionButton extends StatelessWidget {
  final VoidCallback? onActionTap; // Callback pour l'action

  const ConnexionButton({
    Key? key,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: MaterialTheme.lightScheme().surfaceContainerLow,
      width: MediaQuery.of(context).size.width, // Largeur du container
      height: 235,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: MaterialTheme.lightScheme().surfaceContainerLow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), // Rayon en haut à gauche
          topRight: Radius.circular(20),  // Pas de rayon en haut à droite
          bottomLeft: Radius.circular(0), // Rayon en bas à gauche
          bottomRight: Radius.circular(0), // Pas de rayon en bas à droite
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24), // Couleur de l'ombre
            blurRadius: 2, // Rayon de flou
            offset: Offset(0, 0), // Décalage horizontal et vertical
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Texte "Vous n'êtes pas encore connecté"
            Align(
              alignment: Alignment.center,
              child: Text(
                "Vous n'êtes pas encore connecté",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MaterialTheme.lightScheme().onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24), // Espace entre le texte et le bouton

            // Bouton "Créer un compte"
            CustomButton(
              label: "Créer un compte", 
              color: MaterialTheme.lightScheme().primary,
              onPressed: () {
                print("Naviguer vers l'inscription");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),

            const SizedBox(height: 12), // Espace entre les boutons

            // Ligne horizontale avec le texte "OU"
            Row(
              children: [
                Expanded(
                  child: HorizontalLine(color: MaterialTheme.lightScheme().outlineVariant),
                ),
                SizedBox(width: 20),
                Text(
                  'OU',
                  style: TextStyle(
                    fontSize: 14,
                    color: MaterialTheme.lightScheme().secondary,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: HorizontalLine(color: MaterialTheme.lightScheme().outlineVariant),
                ),
              ],
            ),

            const SizedBox(height: 12), // Espace entre la ligne et le bouton "Se connecter"

            // Bouton "Se connecter"
            CustomButton(
              label: "Se connecter", 
              outline: true,
              color: Colors.transparent,
              onPressed: () {
                print("Naviguer vers l'écran de connexion");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );              },
            ),
          ],
        ),
      ),
    );
  }
}
