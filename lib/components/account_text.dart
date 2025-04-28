import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AccountText extends StatelessWidget {
  final String message; // Texte principal (ex : "Vous n'avez pas de compte?")
  final String actionText; // Texte d'action (ex : "Inscrivez-vous")
  final Color? messageColor; // Couleur du texte principal
  final Color? actionTextColor; // Couleur du texte d'action
  final VoidCallback? onActionTap; // Callback pour l'action

  const AccountText({
    Key? key,
    required this.message,
    required this.actionText,
    this.messageColor,// = Colors.black, // Couleur par défaut : noir
    this.actionTextColor,// = Colors.green, // Couleur par défaut : vert
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: message,
            style: TextStyle(
              color: messageColor, // Couleur personnalisée pour le message
              fontSize: 12.0,
            ),
          ),
          WidgetSpan(
            child: SizedBox(width: 4.0), // Espace de 10 pixels
          ),
          
          TextSpan(
            text: " $actionText", // Ajoute un espace entre les deux textes
            style: TextStyle(
              color: actionTextColor, // Couleur personnalisée pour l'action
              fontSize: 14.0,
              fontWeight: FontWeight.bold, // Optionnel : en gras
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = onActionTap, // Exécute l'action lorsque cliqué
          ),
        ],
      ),
    );
  }
}
