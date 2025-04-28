import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/utility/format.dart';
import 'package:rider_register/widgets/line.dart';
import 'package:rider_register/widgets/profile/circ_img_cam.dart';

class ProfileAccountScreen extends StatelessWidget {
  const ProfileAccountScreen({
    super.key,
    required this.setIsShowBotNavBar,
  });

  final Function(bool) setIsShowBotNavBar;
  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    UserRepository userRepository = UserRepository();

    List<MenuItem> menuItems = [
      MenuItem(
        icon: Icons.call_outlined,
        label: 'TELEPHONE',
        description: formatPhoneNumber(deliveryData.userFire!.phoneNumber!),
        // route: MPR.PHONE_NUM,
      ),
      MenuItem(
        icon: Icons.mail_outlined,
        label: 'E-MAIL',
        description: deliveryData.userFire!.email ?? '',
        // route: MPR.MAIL,
      ),
      MenuItem(
          icon: Icons.lock_outlined,
          label: 'MOT DE PASSE',
          description: '..............',
          route: MPR.PWD),
    ];

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        title: const Text('Compte'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setIsShowBotNavBar(true);
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
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
                    navigateTo: () => Navigator.pushNamed(context, '/picture'),
                  ),
                  SizedBox(height: 36.h),
                  NameWidget(
                    nom: deliveryData.userFire!.lastName ?? '',
                    prenom: deliveryData.userFire!.firstName ?? '',
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.v, right: 14.v),
                    child: Column(
                      children: menuItems
                          .map((item) => ListTileBase(item: item))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 17.h),
                  Line(width: 320.v),
                  // SizedBox(height: 16.h),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 24.v),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Adresses',
                  //           textAlign: TextAlign.left,
                  //           style: TextStyle(
                  //             color: scheme.onTertiaryContainer,
                  //             fontSize: 16.fSize,
                  //             fontFamily: 'Roboto',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //         SizedBox(height: 2.h),
                  //         Text(
                  //           'Ajouter des adresses ou des lieux pour faciliter \nvos déplacements et vos livraisons.',
                  //           style: TextStyle(
                  //             color: Color(0xFF456179),
                  //             fontSize: 12.fSize,
                  //             fontFamily: 'Roboto',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 16.h),
                  // SizedBox(
                  //   width: 200.v,
                  //   height: 40.h,
                  //   child: Expanded(
                  //     child: OutlinedButton.icon(
                  //       onPressed: () =>
                  //           Navigator.pushNamed(context, MPR.ADDRESS),
                  //       icon: Icon(
                  //         Icons.bookmark,
                  //         color: scheme.primary,
                  //         size: 24.adaptSize,
                  //       ),
                  //       label: Text(
                  //         'Ajouter des adresses',
                  //         style: TextStyle(
                  //           color: scheme.primary,
                  //           fontSize: 14.fSize,
                  //           fontFamily: 'Roboto',
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 16.h),
                  // Line(width: 320.v),
                  SizedBox(height: 12.h),
                  TextButton.icon(
                    onPressed: () {
                      deliveryData.setMyProfileIsFetching(true);
                      userRepository.signOut().then((value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => AccueilScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      });
                      deliveryData.setMyProfileIsFetching(false);
                      deliveryData.setMyProfileIsEditing(false);
                    },
                    icon: const Icon(Icons.logout_outlined),
                    label: Text(
                      'Déconnexion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10.fSize,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: scheme.error),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            )),
      ),
    );
  }
}

class ListTileBase extends StatelessWidget {
  const ListTileBase({
    super.key,
    required this.item,
    this.trailing,
    this.hasTrailing = true,
    this.arguments,
  });

  final MenuItem item;
  final Widget? trailing;
  final bool hasTrailing;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Center(
        widthFactor: 1,
        child: Icon(item.icon, color: scheme.shadow),
      ),
      title: Text(
        item.label,
        style: TextStyle(
          color: const Color(0xFF456179),
          fontSize: 12.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        item.description,
        style: TextStyle(
          color: scheme.onTertiaryContainer,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: item.route == null
          ? null
          : hasTrailing
              ? trailing == null
                  ? Icon(
                      Icons.chevron_right_rounded,
                      color: scheme.shadow,
                      size: 24.adaptSize,
                    )
                  : trailing
              : null,
      onTap: item.route == null
          ? null
          : () => Navigator.pushNamed(
                context,
                item.route!,
                arguments: arguments,
              ),
    );
  }
}

class NameWidget extends StatelessWidget {
  const NameWidget({
    super.key,
    required this.nom,
    required this.prenom,
  });

  final String nom, prenom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.v, right: 14.v),
      child: ListTile(
        leading: Center(
          widthFactor: 1,
          child: Icon(
            Icons.person_outline,
            color: scheme.shadow,
          ),
        ),
        title: const TitleRow(),
        subtitle: SubtitleRow(prenom: prenom, nom: nom),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: scheme.shadow,
          size: 24.adaptSize,
        ),
        onTap: () {
          // Navigator.pushNamed(context, MPR.IDENTITY);
        },
      ),
    );
  }
}

class SubtitleRow extends StatelessWidget {
  const SubtitleRow({
    super.key,
    required this.nom,
    required this.prenom,
  });

  final String nom, prenom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double itemW = (constraints.maxWidth.v - 24.v - 14.v) / 2;
      return Row(
        children: [
          SizedBox(
            width: itemW,
            child: Text(
              nom,
              style: TextStyle(
                color: scheme.onTertiaryContainer,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: itemW,
            child: Text(
              prenom,
              style: TextStyle(
                color: scheme.onTertiaryContainer,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double itemW = (constraints.maxWidth.v - 24.v - 14.v) / 2;
      return Row(
        children: [
          SizedBox(
            width: itemW,
            child: Text(
              'NOM',
              style: TextStyle(
                color: const Color(0xFF456179),
                fontSize: 12.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: itemW,
            child: Text(
              'PRENOM',
              style: TextStyle(
                color: const Color(0xFF456179),
                fontSize: 12.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class MenuItem {
  final IconData icon;
  final String label, description;
  final String? route;

  MenuItem(
      {required this.icon,
      required this.label,
      required this.description,
      this.route});
}
