import 'package:flutter/material.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';

class ProfileAddressHouseScreen extends StatelessWidget {
  const ProfileAddressHouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'Maison';

    return BaseTdsScreen(
      title: title,
      desc:
          'Votre adresse de maison facilite des livraisons précises et rapides.',
      sub:
          'Vos informations personnelles restent confidentielles \net sécurisées.',
      children: [],
    );
  }
}
