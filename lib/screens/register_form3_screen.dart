import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider_register/screens/register_form4_vehicle_sreen.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:rider_register/widgets/clip_r_rect_picture.dart';
import 'package:rider_register/widgets/register_form1_modal_bottom_sheet.dart';
import 'package:rider_register/widgets/sized_box_height.dart';

class RegisterForm3Screen extends StatefulWidget {
  const RegisterForm3Screen({super.key});

  @override
  State<RegisterForm3Screen> createState() => _RegisterForm3ScreenState();
}

class _RegisterForm3ScreenState extends State<RegisterForm3Screen> {
  final _image =
      'assets/images/external-transportation-literary-genres-becris-solid-becris.png';
  var _file = null;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitIdRegisterForm3!,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider Register ${AppLocalizations.of(context)!.step} 3"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRectPicture(
                  path: _file == null ? "" : _file.path, image: _image),
              const SizedBoxHeight(height: "sm"),
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.setDriverLicense),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '**** **** **** ****',
                      labelText: AppLocalizations.of(context)!.driverLicense),
                ),
              ),
              const SizedBoxHeight(height: "sm"),
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.next),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegisterForm4VehicleScreen()));
                },
              ),
            ],
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
