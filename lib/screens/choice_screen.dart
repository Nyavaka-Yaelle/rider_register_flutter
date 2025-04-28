import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/screens/login_screen.dart';
import 'package:rider_register/screens/register_screen.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';
import 'package:rider_register/widgets/custom_outlined_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({Key? key}) : super(key: key);

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final PageController _controller = PageController();
  final PageController _controllerTitle = PageController();
  final PageController _controllerText = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const int seconds = 3;
    _timer = Timer.periodic(Duration(seconds: seconds), (_) {
      _navigateToNextPage();
    });
  }

  void _navigateToNextPage() {
    _currentPage = (_currentPage + 1) % 4;
    _animateToPage(_currentPage);
  }

  void _animateToPage(int page) {
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 20), curve: Curves.ease);
    _controllerTitle.animateToPage(page,
        duration: Duration(milliseconds: 20), curve: Curves.ease);
    _controllerText.animateToPage(page,
        duration: Duration(milliseconds: 20), curve: Curves.ease);
  }

  List<Widget> _buildPageViewIndicator(BuildContext context) {
    final imagePaths = [
      ImageConstant.imgRideeJustLogo,
      ImageConstant.imgRideeCircle,
      ImageConstant.imgFoodeeCircle,
      ImageConstant.imgPakceeCircle,
    ];

    return imagePaths
        .map((imagePath) => CustomImageView(
              imagePath: imagePath,
              height: 283.v,
              width: 281.h,
            ))
        .toList();
  }

  List<Widget> _buildPageViewIndicatorTitle(BuildContext context) {
    final titles = [
      "Dagô",
      "Ridee",
      "Foodee",
      "Packee",
    ];

    return titles
        .map((title) => FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
            ))
        .toList();
  }

  List<Widget> _buildPageViewIndicatorText(BuildContext context) {
    final texts = [
      "L’application qui révolutionne votre quotidien\nLe changement dans vos mains",
      "Vos déplacements n’ont jamais été si facile là où vous êtes votre transport vient vers vous",
      "Commandez vos plats préférés et faites-vous livrer dans le plus bref délai.",
      "Soyez sans crainte vos colis seront livrés chez vous. Suivez en temps réel votre livraison",
    ];

    return texts
        .map((text) => Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                height: 1.50,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 39.v),
              Column(
                children: [
                  Container(
                    width: 200.v,
                    height: 200.v,
                    child: PageView(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        _currentPage = index;
                        setState(() {});
                      },
                      children: _buildPageViewIndicator(context),
                    ),
                  ),
                  SizedBox(height: 54.v),
                  SizedBox(
                    height: 8.v,
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: _buildPageViewIndicator(context).length,
                      effect: ExpandingDotsEffect(
                        spacing: 4,
                        activeDotColor: scheme.secondaryContainer,
                        dotColor: scheme.secondaryContainer,
                        dotHeight: 8.v,
                        dotWidth: 8.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Container(
                    width: 400.v,
                    height: 52.h,
                    child: PageView(
                      controller: _controllerTitle,
                      physics: NeverScrollableScrollPhysics(),
                      children: _buildPageViewIndicatorTitle(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 340.h,
                    height: 52.h,
                    child: PageView(
                      controller: _controllerText,
                      physics: NeverScrollableScrollPhysics(),
                      children: _buildPageViewIndicatorText(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.v),
              CustomElevatedButton(
                text: "S’inscrire",
                margin: EdgeInsets.symmetric(horizontal: 6.h),
                onPressed: () => onTapRegisterButton(context),
              ),
              SizedBox(height: 16.v),
              CustomOutlinedButton(
                text: "Se connecter",
                margin: EdgeInsets.symmetric(horizontal: 6.h),
                onPressed: () => onTapLoginButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapLoginButton(BuildContext context) =>
      _navigateToScreen(context, LoginScreen());

  void onTapRegisterButton(BuildContext context) =>
      _navigateToScreen(context, RegisterScreen());

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
