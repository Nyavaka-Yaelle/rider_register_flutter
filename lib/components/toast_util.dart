import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  // Fonction pour afficher un toast
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // Durée d'affichage
      gravity: ToastGravity.BOTTOM, // Position du toast
      timeInSecForIosWeb: 1, // Durée sur iOS (optionnel)
      backgroundColor: Colors.red, // Couleur du fond
      textColor: Colors.white, // Couleur du texte
      fontSize: 16.0, // Taille du texte
    );
  }
}
