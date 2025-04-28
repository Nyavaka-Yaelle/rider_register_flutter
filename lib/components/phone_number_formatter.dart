import 'package:flutter/services.dart';

// Formateur pour numéro de téléphone avec des espaces
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(' ', ''); // Supprimer les espaces
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == 5 || i == 8) {
        buffer.write(' '); // Ajouter un espace après les indices spécifiques
      }
      buffer.write(newText[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
