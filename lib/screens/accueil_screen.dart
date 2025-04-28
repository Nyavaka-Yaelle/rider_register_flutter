import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/screens/home_finally_page/Accueille.dart';
import 'package:rider_register/screens/choice_screen.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/rate_screen.dart';
import 'package:rider_register/screens/foodee_home_screen.dart';
import 'package:rider_register/screens/notifs_screen.dart';
class AccueilScreen extends StatefulWidget {
  const AccueilScreen({Key? key}) : super(key: key);
  @override
  _AccueilScreenState createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  String _selectedOption = 'EN';
  final UserRepository userRepository = UserRepository();
  String? currentid;
  UserFire.User? user;
  @override
  initState() {
    currentid = userRepository.getCurrentUser()?.uid;
    if (currentid != null) {
      //redirect to home page screen
      print(" logged in with id $currentid");
      userRepository.getUserById(currentid!).then((UserFire.User? result) {
        //Do whatever you want with the result value
        print("${result?.displayName} WTFFFF");
        SessionManager().set("user", result);
        Provider.of<DeliveryData>(context, listen: false);
        context.read<DeliveryData>().setUserFire(result);
        // setState(() {
        //   user = result;
        // });
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Accueille()));
      });
    } else {
      print("not logged in");
      Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Accueille()));
        setState(() {
          // Here you can write your code for open new view
        });
      });
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray70,
      body: Center(
        child: Image.asset('assets/logo/dagologoios.png'),
      ),
    );
  }
}
