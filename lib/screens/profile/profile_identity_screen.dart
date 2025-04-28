import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/utility/printanah.dart';

class ProfileIdentityScreen extends StatelessWidget {
  const ProfileIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    final TextEditingController _fnCtrl =
            TextEditingController(text: deliveryData.userFire!.firstName),
        _lnCtrl = TextEditingController(text: deliveryData.userFire!.lastName),
        _dnCtrl =
            TextEditingController(text: deliveryData.userFire!.displayName);

    bool isEmpty = deliveryData.userFire?.profilePicture == "";

    save() {
      try {
        FocusScope.of(context).unfocus();
        final deliveryData = Provider.of<DeliveryData>(context, listen: false);
        deliveryData.userFire!.displayName = _dnCtrl.text;
        deliveryData.userFire!.firstName = _fnCtrl.text;
        deliveryData.userFire!.lastName = _lnCtrl.text;
        deliveryData.updateUserFire(deliveryData.userFire);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Vos informations ont été mises à jour',
          )),
        );
      } catch (e) {
        printredinios('Error: $e');
      }
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        actions: [
          GestureDetector(
            onTap: () {
              print('Avatar tapped!');
            },
            child: isEmpty
                ? Icon(
                    Icons.account_circle_outlined,
                    size: 20.adaptSize,
                  )
                : CustomImageView(
                    imagePath: deliveryData.userFire!.profilePicture,
                    height: 20.v,
                    width: 20.v,
                    radius: BorderRadius.all(Radius.circular(20.v)),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
          ),
          SizedBox(width: 18.v),
        ],
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
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.v),
                    child: Text(
                      'Identifiant',
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 24.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 58.h),
                  TextFieldIcon(
                      icon: Icon(
                        Icons.person_outline,
                        color: scheme.shadow,
                        size: 20.adaptSize,
                      ),
                      padding: EdgeInsets.only(left: 16.v, right: 24.v),
                      labelText: 'Pseudo',
                      controller: _dnCtrl),
                  SizedBox(height: 20.h),
                  TextFieldIcon(
                    padding: EdgeInsets.only(left: 16.v, right: 24.v),
                    labelText: 'Nom',
                    controller: _lnCtrl,
                  ),
                  SizedBox(height: 20.h),
                  TextFieldIcon(
                      padding: EdgeInsets.only(left: 16.v, right: 24.v),
                      labelText: 'Prénom',
                      controller: _fnCtrl),
                  SizedBox(height: 34.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 74.v,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: scheme.primary,
                              fontSize: 14.fSize,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Annuler'),
                        ),
                      ),
                      SizedBox(width: 24.v),
                      SizedBox(
                        width: 113.v,
                        child: FilledButton(
                          onPressed: save,
                          child: const Text('Enregistrer'),
                        ),
                      ),
                      SizedBox(width: 24.v),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class TextFieldIcon extends StatefulWidget {
  const TextFieldIcon({
    super.key,
    required this.labelText,
    this.icon,
    this.padding,
    this.obscure,
    this.controller,
  });

  final String labelText;
  final Icon? icon;
  final EdgeInsetsGeometry? padding;
  final bool? obscure;
  final TextEditingController? controller;

  @override
  State<TextFieldIcon> createState() => _TextFieldIconState();
}

class _TextFieldIconState extends State<TextFieldIcon> {
  @override
  Widget build(BuildContext context) {
    bool _obscureText = widget.obscure ?? false;
    return Padding(
      padding: widget.padding ?? EdgeInsets.only(),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        widget.icon ??
            Icon(
              Icons.person_outline,
              color: Colors.transparent,
              size: 20.adaptSize,
            ),
        SizedBox(width: 12.v),
        Expanded(
            child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            hintStyle: TextStyle(
              color: scheme.onSurface,
              fontSize: 16.fSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: widget.obscure!
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    })
                : null,
          ),
        ))
      ]),
    );
  }
}
