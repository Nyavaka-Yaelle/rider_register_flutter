import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:rider_register/widgets/profile/circ_img_cam.dart';

class ProfileHomeScreen extends StatefulWidget {
 final VoidCallback onPressed;

  const ProfileHomeScreen({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}
class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final deliveryData = Provider.of<DeliveryData>(context, listen: false);
      deliveryData.setUserFire(deliveryData.userFire);
    });
  }

  @override
  Widget build(BuildContext context) {
    DeliveryData deliveryData = Provider.of<DeliveryData>(context, listen: true);
  //  deliveryData.setUserFire(deliveryData.userFire);
    printredinios(deliveryData.userFire?.profilePicture ?? "null");
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.0, color: scheme.onSurfaceVariant,), // Flèche "Retour"
          onPressed: widget.onPressed
        ),
        title: Text(' Profil'),
        centerTitle: true,
      ),
      body: deliveryData.userFire == null
          ? Container()
          : SafeArea(
              child: WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context);
                    deliveryData.setMyProfileIsEditing(false);
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircImgCam(
                          url: deliveryData.userFire?.profilePicture,
                          navigateTo: () =>
                              Navigator.pushNamed(context, '/picture'),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          deliveryData.userFire?.displayName ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 16.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          deliveryData.userFire!.email ?? '',
                          style: TextStyle(
                            color: scheme.secondary,
                            fontSize: 12.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.v),
                          child: Column(
                            children: menuItems.map((item) {
                              return ListTile(
                                leading: Center(
                                  child: Icon(item.icon, color: scheme.shadow),
                                  widthFactor: 1,
                                ),
                                title: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: scheme.onTertiaryContainer,
                                    fontSize: 16.fSize,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                subtitle: Text(
                                  item.description,
                                  style: TextStyle(
                                    color: Color(0xFF456179),
                                    fontSize: 12.fSize,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () =>
                                    Navigator.pushNamed(context, item.route),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String label, description, route;

  MenuItem(
      {required this.icon,
      required this.label,
      required this.description,
      required this.route});
}

List<MenuItem> menuItems = [
  MenuItem(
    icon: Icons.person,
    label: 'Compte',
    description: 'Vos informations personnelles',
    route: '/account',
  ),
  // MenuItem(
  //   icon: Icons.history,
  //   label: 'Historique',
  //   description: 'Vos divers historiques',
  //   route: '/story',
  // ),
  // MenuItem(
  //   icon: Icons.wallet,
  //   label: 'Wallet',
  //   description: 'Gérer vos paiements',
  //   route: '/wallet',
  // ),
  // MenuItem(
  //   icon: Icons.settings,
  //   label: 'Paramètres',
  //   description: 'Paramètres de l\'application',
  //   route: '/settings',
  // ),
];
