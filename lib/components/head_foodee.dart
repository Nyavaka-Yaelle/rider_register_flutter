import 'package:flutter/material.dart';
import './custom_item.dart';
import './custom_icon_button.dart';
import '../theme.dart'; // Importez le fichier TabItem si nécessaire
import 'package:rider_register/screens/restaurants_screen.dart';

class HeadFoodee extends StatefulWidget {
  final int index;

  HeadFoodee({Key? key, required this.index});

  @override
  _HeadFoodeeState createState() => _HeadFoodeeState();
}

class _HeadFoodeeState extends State<HeadFoodee> {
  int _selectedIndex = 0;
  bool _isButtonPressed = false;

  void onPressed() {
    setState(() {
      _isButtonPressed = true;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isButtonPressed = false;
      });

      print("Voir tout pressed $_selectedIndex");
      if (widget.index == 1) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 600), // Adjust the duration here
            pageBuilder: (context, animation, secondaryAnimation) => RestaurantsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  bool isActive(id) {
    return id == _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Row(
          children: [
            Spacer(),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: _isButtonPressed
                  ? Matrix4.translationValues(0, -5, 0)
                  : Matrix4.translationValues(0, 0, 0),
              child: CustomIconButton(
                label: "Voir tout",
                onPressed: onPressed,
                icon: Icons.arrow_right_alt_rounded,
                color: MaterialTheme.lightScheme().primaryContainer,
              ),
            ),
          ],
        ),
        // Other UI elements...
      ]),
    );
  }
}