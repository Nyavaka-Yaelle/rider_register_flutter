import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:rider_register/models/user.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/repository/note_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/screens/home_finally_page/Accueille.dart';
import 'package:rider_register/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';
import 'package:rider_register/widgets/custom_icon_button.dart';
import 'package:rider_register/widgets/ridee/coffee.dart';
import 'package:rider_register/widgets/wallet/card_rider_contact.dart';
import 'package:rider_register/core/app_export.dart';
import '../main.dart';
import '../models/note.dart';
import 'mydelivery_screen.dart';
import 'myprofile_screen.dart';

// Define the first screen as a stateful widget
class RateScreen extends StatefulWidget {
  final String? idlivraison;

  const RateScreen({required this.idlivraison});
  @override
  _RateScreenState createState() => _RateScreenState();
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

//functino that concatenante two string with two argument , the string to concatenate and the string to concatenate with
String concatenate(String toconcatenate, String toconcatenatewith) {
  if (toconcatenate == "") {
    return toconcatenatewith;
  } else {
    return toconcatenate + "," + toconcatenatewith;
  }
}

//Function that return a readable string of a timestamp using 24h
String readableTime(Timestamp timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  var format = DateFormat.yMMMMEEEEd('fr_FR');
  return format.format(date);
}

//function that search for a string in a string and remove it
String remove(String toremove, String toremovewith) {
  if (toremove.contains(toremovewith + ",")) {
    return toremove.replaceAll(toremovewith + ",", '');
  }
  if (toremove.contains("," + toremovewith)) {
    return toremove.replaceAll("," + toremovewith, '');
  } else {
    return toremove.replaceAll(toremovewith, '');
  }
}

// Define the state of the first screen
class _RateScreenState extends State<RateScreen> {
  void handleAmountSelected(int selectedAmount) {
    setState(() {
      // Update the selected amount
      pourboire = selectedAmount.toString();
      print('Selected amount: $pourboire');
    });
    // You can also update the state or perform other actions here
  }
  //show loading screen function

//loading screen
  bool _isLoading = false;
  //to add
  String toconcatenate = '';
  String pourboire = '';
  String rating = '';
  String ratingsheet = '3.0';
  String commentaire = '';
  //Textfield controller
  TextEditingController _commentaireController = TextEditingController();
  // Define a future that waits for x seconds and returns true
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  String googleApiKey = 'AIzaSyAeFMQ-GoJPC_Sz5np7Rd0rs0bETERtSc8';
  String totalDistance = 'No route';
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Uint8List? markerIcon;
  Livraison livraison = Livraison.empty();
  Rider user = Rider.empty();
  LivraisonRepository livraisonRepository = LivraisonRepository();
  UserRepository userRepository = UserRepository();
  NoteRepository noteRepository = NoteRepository();
  Circle circle = Circle(circleId: CircleId('myCircle'));
  BitmapDescriptor? bitmapDescriptor;
  Color price500color = scheme.onPrimary;
  Color border500color = Color.fromARGB(255, 31, 27, 27);
  Color text500color = Color.fromARGB(255, 31, 27, 27);
  static const Color green = Color(0xFF159b8b);
  Color price1000color = scheme.onPrimary;
  Color border1000color = Color.fromARGB(255, 31, 27, 27);
  Color text1000color = Color.fromARGB(255, 31, 27, 27);

  Color price1500color = scheme.onPrimary;
  Color border1500color = Color.fromARGB(255, 31, 27, 27);
  Color text1500color = Color.fromARGB(255, 31, 27, 27);

  Color price2000color = scheme.onPrimary;
  Color border2000color = Color.fromARGB(255, 31, 27, 27);
  Color text2000color = Color.fromARGB(255, 31, 27, 27);

  Color price3000color = scheme.onPrimary;
  Color border3000color = Color.fromARGB(255, 31, 27, 27);
  Color text3000color = Color.fromARGB(255, 31, 27, 27);

  Color price5000color = scheme.onPrimary;
  Color border5000color = Color.fromARGB(255, 31, 27, 27);
  Color text5000color = Color.fromARGB(255, 31, 27, 27);

  //ameliorer
  Color text1color = scheme.onPrimary;
  Color bordertext1color = Color.fromARGB(255, 31, 27, 27);
  Color texttext1color = Color.fromARGB(255, 31, 27, 27);

  Color text2color = scheme.onPrimary;
  Color bordertext2color = Color.fromARGB(255, 31, 27, 27);
  Color texttext2color = Color.fromARGB(255, 31, 27, 27);

  Color text3color = scheme.onPrimary;
  Color bordertext3color = Color.fromARGB(255, 31, 27, 27);
  Color texttext3color = Color.fromARGB(255, 31, 27, 27);

  Color text4color = scheme.onPrimary;
  Color bordertext4color = Color.fromARGB(255, 31, 27, 27);
  Color texttext4color = Color.fromARGB(255, 31, 27, 27);

  Color text5color = scheme.onPrimary;
  Color bordertext5color = Color.fromARGB(255, 31, 27, 27);
  Color texttext5color = Color.fromARGB(255, 31, 27, 27);

  Color text6color = scheme.onPrimary;
  Color bordertext6color = Color.fromARGB(255, 31, 27, 27);
  Color texttext6color = Color.fromARGB(255, 31, 27, 27);
  int _currentIndex = 0;

// bottom sheet
  void _showBottomSheet() {
    showCustomBottomSheet<void>(
      //height is size of the screen

      height: MediaQuery.of(context).size.height - 100,
      context,
      children: [
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Icon(
                Icons.check_circle_outline,
                // color: scheme.onPrimaryFixedVariant,
                size: 24,
              ),
            ),
            SizedBox(width: 8.v),
            Text(
              'Vous êtes arrivé !',
              style: TextStyle(
                color: scheme.shadow,
                fontSize: 16.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            )
          ],
        ),
        SizedBox(height: 5.h),
        CardRiderContact(
          motor: '423TBL',
          rider: user.displayName ?? "",
          riderImg: user.profilePicture ?? "",
          star: 4,
          locations: [
            livraison.namePlaceDepart ?? 'Unknown',
            livraison.multipointsAddress?.first ?? 'Unknown'
          ],
          bill: livraison.prix!.toInt(),
          date: readableTime(livraison.dateenregistrement ?? Timestamp.now()),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 344.v,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: scheme.surfaceBright,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Text(
                'Comment s’est déroulé votre déplacement ? ',
                style: TextStyle(
                  color: scheme.onSecondaryContainer,
                  fontSize: 14.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10.v,
                ),
              ),
              SizedBox(height: 4.h),
              RatingBar(
                rating: 3,
                onRatingUpdate: (rating) {
                  ratingsheet = rating.toString();
                  print("rating sheet" + ratingsheet);
                },
              ),
              SizedBox(height: 11.h),
            ],
          ),
        ),
        Coffee(
          isExtended: true,
          onTap: () {},
          onAmountSelected: handleAmountSelected,
        ),
// print("dsds" + Coffee.selectedAmount);
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomElevatedButton(
                width: 328.v,
                height: 40.h,
                text: "Passer",
                buttonStyle:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Add your logic here for the "Annuler" button
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Accueille()),
                    );
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(width: 16.v), // Add some space between the buttons
            Expanded(
              child: CustomElevatedButton(
                width: 328.v,
                height: 40.h,
                text: "Valider",
                onPressed: () {
                  // Add your logic here
                  if (pourboire == "") {
                    // Code to handle the case where pourboire is an empty string
                    pourboire = "0.0";
                  }
                  if (rating == "") {
                    // Code to handle the case where rating is an empty string
                    rating = "3.0";
                  }

                  print("To add " +
                      toconcatenate +
                      " " +
                      ratingsheet +
                      " " +
                      _commentaireController.text +
                      " " +
                      pourboire +
                      " " +
                      livraison!.idrider! +
                      " ");
                  // Note notetoadd = Note(
                  //     idlivraison: widget.idlivraison,
                  //     idrider: livraison!.idrider,
                  //     commentaire: "",
                  //     pourboire: double.parse(pourboire),
                  //     note: double.parse(rating),
                  //     ameliorer: "");
                  // noteRepository.addNote(notetoadd);
                  // // Future delayed to redirect to the home page milliseconds
                  // Future.delayed(const Duration(milliseconds: 500), () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Accueille()),
                  //   );
                  // });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 23.h),
      ],
    );
    setState(() {
      _isLoading = false;
    });
  }

  // Define a variable to store the index of the selected item
  int selectedIndex = -1;
  final rider = [
    {
      'image': 'assets/images/zelda.jpg',
      'title': 'Melo',
      'description': 'You are the one and only',
      'number': '5',
      'anothertext': '2-4 personnes',
    },
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Delay for 500ms

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Accueille()),
              (route) => false);
        });
      }
      if (_currentIndex == 1) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
          // );
        });
      }
      if (_currentIndex == 4) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
          // );
        });
      }
      print('index: $_currentIndex');
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      markerIcon = await getBytesFromAsset('assets/images/anya.png', 64);
      bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
      user.displayName = "";
      //set marker for depart and arrivee
      Marker markerDepart = Marker(
        markerId: MarkerId('Vous'),
        position: test1,
        infoWindow: InfoWindow(title: 'Vous'),
      );
      Marker markerArrivee = Marker(
        markerId: MarkerId('Rider'),
        position: test2,
        infoWindow: InfoWindow(title: 'Rider'),
        icon: bitmapDescriptor!,
      );
      //add marker to map
      Livraison? livraisonto =
          await livraisonRepository.getLivraisonById(widget.idlivraison!);
      Rider? userto =
          await userRepository.getRiderByUserById(livraisonto!.idrider!);
      setState(() {
        livraison = livraisonto;
        user = userto!;
        print("user ${user.displayName}");
        _markers.add(markerDepart);
        _markers.add(markerArrivee);
        Future.delayed(Duration(seconds: 0)).then((_) {
          _showBottomSheet();
        });
      });
    });

    circle = circle.copyWith(
      centerParam: test1, // Set circle center as same as marker position
      radiusParam: 2000, // Set circle radius as 1km (1000 meters)
      fillColorParam: Color(0xFF00AD9C)!.withOpacity(
          0.5), // Set circle fill color as purple with some transparency
      strokeColorParam: Color(
          0xFF00AD9C), // Set circle stroke color as purple with some transparency
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Screen'),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: screenHeight,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Opacity(
                opacity: 0.1,
                child: ModalBarrier(dismissible: false, color: scheme.shadow),
              ),
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class RatingBar extends StatefulWidget {
  final double rating;
  final Function(double) onRatingUpdate;

  const RatingBar(
      {Key? key, required this.rating, required this.onRatingUpdate})
      : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();

    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) => _buildStar(index)),
    );
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _currentRating ? Icons.star : Icons.star_border,
        // color: scheme.onPrimaryFixedVariant,
        size: 48.adaptSize,
      ),
      onPressed: () {
        setState(() {
          _currentRating = index + 1.0;
        });
        widget.onRatingUpdate(_currentRating);
      },
    );
  }
}
