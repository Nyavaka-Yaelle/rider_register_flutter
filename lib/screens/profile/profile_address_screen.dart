import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_account_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/widgets/line.dart';

class ProfileAddressScreen extends StatelessWidget {
  const ProfileAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'Adresses';

    return BaseTdsScreen(
      title: title,
      desc:
          'Vos adresses dans l’application permet de simplifier\net d’optimiser vos déplacements et livraisons.',
      sub:
          'Vos informations personnelles restent confidentielles \net sécurisées.',
      children: [
        SizedBox(height: 18.h),
        Head(label: 'Adresses personnelles'),
        ListTileBase(
          item: MenuItem(
            icon: Icons.house_outlined,
            label: 'MAISON',
            description: 'Cité des 67Ha Sud',
            route: MPR.ADDRESS_TYPE,
          ),
          arguments: {
            'title': 'Maison',
            'desc':
                'Votre adresse de maison facilite des livraisons\nprécises et rapides.',
            'sub':
                'Vos informations personnelles restent confidentielles \net sécurisées.',
            'children': [
              ListTileBase(
                item: MenuItem(
                  icon: Icons.house_outlined,
                  label: 'MAISON',
                  description: 'Cité des 67Ha Sud',
                  route: 'test',
                ),
                trailing: Icon(Icons.edit_outlined),
              ),
              SizedBox(height: 16.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add_outlined),
                  label: Text(
                    'Ajouter une adresse de maison',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 14.fSize,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.10.fSize,
                    ),
                  ),
                ),
              ]),
            ],
          },
        ),
        ListTileBase(
          item: MenuItem(
            icon: Icons.work_outline_outlined,
            label: 'BUREAU',
            description: 'Ajouter une adresse',
            route: 'test',
          ),
          trailing: Icon(Icons.add),
        ),
        Line(width: double.infinity),
        SizedBox(height: 16.h),
        Head(label: 'Restaurants favoris'),
        ListTileBase(
          item: MenuItem(
            icon: Icons.restaurant,
            label: 'RESTAURANT',
            description: 'Sopera Milomboko',
            route: 'test',
          ),
          trailing: Icon(Icons.favorite),
        ),
        ListTileBase(
          item: MenuItem(
            icon: Icons.restaurant,
            label: 'RESTAURANT',
            description: 'Ajouter une adresse',
            route: 'test',
          ),
          trailing: Icon(Icons.add),
        ),
      ],
    );
  }
}

class Head extends StatelessWidget {
  const Head({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: scheme.tertiary,
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.50.v,
      ),
    );
  }
}
