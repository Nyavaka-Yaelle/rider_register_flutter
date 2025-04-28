import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rider_register/screens/register_form2_screen.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:rider_register/widgets/circle_avatar_picture.dart';
import 'package:rider_register/widgets/register_form1_modal_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider_register/widgets/sized_box_height.dart';

class RegisterForm1Screen extends StatefulWidget {
  const RegisterForm1Screen({super.key});

  @override
  State<RegisterForm1Screen> createState() => _RegisterForm1ScreenState();
}

class _RegisterForm1ScreenState extends State<RegisterForm1Screen> {
  final _image = 'assets/images/logo.png';
  var _file;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitIdRegisterForm1!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void _openImagePicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);
    if (photo != null) {
      setState(() {
        _file = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _fullName, _phoneNumber;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rider Register ${AppLocalizations.of(context)!.step} 1/4"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatarPicture(
                    path: _file == null ? "" : _file.path, image: _image),
                const SizedBoxHeight(height: "sm"),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.setProfilePicture),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return RegisterForm1ModalBottomSheet(
                            openImagePicker: _openImagePicker,
                          );
                        });
                  },
                ),
                const SizedBoxHeight(height: "sm"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'RAKOTO Soa',
                      labelText: AppLocalizations.of(context)!.fullName,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) => _fullName = value!,
                  ),
                ),
                const SizedBoxHeight(height: "sm"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.phoneNumber,
                      hintText: '+2613********',
                    ),
                  ),
                ),
                const SizedBoxHeight(height: "sm"),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.next),
                  onPressed: () {
                    // if (_file == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text("Sending Message"),
                    //   ));
                    //   return;
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterForm2Screen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bannerAd == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
