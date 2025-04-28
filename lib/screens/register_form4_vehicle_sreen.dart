// input picture bicycle
// input color

// input picture bike
// input picture permis
// input color
// input plaque

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider_register/screens/pending_approval_screen.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:rider_register/widgets/clip_r_rect_picture.dart';
import 'package:rider_register/widgets/register_form1_modal_bottom_sheet.dart';
import 'package:rider_register/widgets/sized_box_height.dart';

class RegisterForm4VehicleScreen extends StatefulWidget {
  const RegisterForm4VehicleScreen({super.key});

  @override
  State<RegisterForm4VehicleScreen> createState() =>
      _RegisterForm4VehicleScreenState();
}

class _RegisterForm4VehicleScreenState
    extends State<RegisterForm4VehicleScreen> {
  final _image =
      'assets/images/external-transportation-literary-genres-becris-solid-becris.png';
  var _file = null;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  String vehicle_brand = "";
  String vehicle_color = "";
  String vehicle_license_plate = "";

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
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
        onAdLoaded: (ad) => _interstitialAd = ad,
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const PendingApprovalScreen()),
          );
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownvalue = AppLocalizations.of(context)!.motorbike;
    List<String> items = [
      AppLocalizations.of(context)!.motorbike,
      AppLocalizations.of(context)!.bicycle,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Rider Register ${AppLocalizations.of(context)!.step} 4"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                    print(dropdownvalue);
                    print(newValue);
                  },
                  decoration: const InputDecoration(
                    labelText: 'xxvehicleType',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (dropdownvalue == AppLocalizations.of(context)!.motorbike)
                Column(
                  children: [
                    const SizedBoxHeight(height: "sm"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Karenjy',
                            labelText: "xxvehicleBrand"),
                      ),
                    ),
                    const SizedBoxHeight(height: "sm"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: '**** ***',
                            labelText: "xx_vehicle_license_plate"),
                      ),
                    ),
                    const SizedBoxHeight(height: "sm"),
                    ClipRRectPicture(
                        path: _file == null ? "" : _file.path, image: _image),
                    const SizedBoxHeight(height: "sm"),
                    ElevatedButton(
                      child: Text("xxChangeVehiclePicture"),
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
                  ],
                ),
              const SizedBoxHeight(height: "sm"),
              ElevatedButton(
                onPressed: () => _showInterstitialAd(),
                child: const Text("xx S'inscrire"),
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
