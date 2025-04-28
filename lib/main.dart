import 'dart:io';
import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rider_register/models/cart_foodee_item.dart';
import 'package:rider_register/models/restaurant.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/newmaplive.dart';
import 'package:rider_register/screens/rate_screen.dart';
import 'package:rider_register/screens/rechooserider_screen.dart';
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:rider_register/screens/home_finally_page/Accueille.dart';

// appareiluser_repository.dart
import 'package:rider_register/repository/appareiluser_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_register/screens/verify_otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rider_register/models/user.dart' as UserFire;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//get current user
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rider_register/core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();
bool isNotified = false;
AppareilUserRepository appareilUserRepository = AppareilUserRepository();
String uid = "";
void _handleMessage(RemoteMessage message) {
  isNotified = true;
   if(FirebaseAuth.instance.currentUser!.uid != null){
    uid = FirebaseAuth.instance.currentUser!.uid;
    }
  print("clicked notif handlemessage");
  appareilUserRepository.insertNotifUser(
      message.data["idLivraison"].toString(),
      uid,
      message.notification!.title.toString(),
      message.notification!.body.toString());
  //handle notification from backend here
  //navigate to the delivery detail page
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (message.notification!.title.toString() !=
            "Vous etes arrivé à destination" &&
        message.notification!.title.toString() !=
            "Votre rider a annulée la course!" &&
        message.notification!.title.toString() !=
            "Votre Commande a été annulé") {
      Navigator.of(navigatorKey.currentState!.overlay!.context)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              Newmaplive(idLivraison: message.data["idLivraison"]),
        ),
        (route) => false,
      );
    }
    if (message.notification!.title.toString() ==
        "Votre rider a annulée la course!") {
      Navigator.of(navigatorKey.currentState!.overlay!.context)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => RechooseriderScreen(
              idRider: message.data["idRider"],
              idLivraison: message.data["idLivraison"]),
        ),
        (route) => false,
      );
    }
    if (message.notification!.title.toString() ==
            "Vous etes arrivé à destination" ||
        message.notification!.title.toString() ==
            "Vous etes arrivé à votre derniere destination" ||
        message.notification!.title.toString() ==
            "Votre livreur est chez vous") {
      Navigator.of(navigatorKey.currentState!.overlay!.context)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              RateScreen(idlivraison: message.data["idLivraison"]),
        ),
        (route) => false,
      );
    }
  });
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  Navigator.of(navigatorKey.currentState!.overlay!.context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => Accueille(),
    ),
    (route) => false,
  );
  print("setupinteractedmessage");
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  print("initialMessage: $initialMessage");

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  } else {
    Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
    _stream.listen((RemoteMessage event) async {
      if (event.data != null) {
        print("clicked from not terminated");
      }
    });
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  
  Navigator.of(navigatorKey.currentState!.overlay!.context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => Accueille(),
    ),
    (route) => false,
  );
  print("background when app is not terminated");
  //await Firebase.initializeApp();

  print(
      "Handling a background message: ${message.data["idLivraison"].toString()}");
}

Future<void> main() async {
  print("isnotified " + isNotified.toString());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest, // Pour iOS, utilise App Attest
  );

  Future<void> _showAlertDialog(RemoteMessage message) async {
    print("show dialog");
    return showDialog<void>(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Text(message.notification!.title.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message.notification!.body.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Voir'),
              onPressed: () {
                if (message.notification!.title.toString() !=
                        "Vous etes arrivé à destination" &&
                    message.notification!.title.toString() !=
                        "Votre rider a annulée la course!") {
                  Navigator.of(navigatorKey.currentState!.overlay!.context)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          Newmaplive(idLivraison: message.data["idLivraison"]),
                    ),
                    (route) => false,
                  );
                }
                if (message.notification!.title.toString() ==
                    "Votre rider a annulée la course!") {
                  Navigator.of(navigatorKey.currentState!.overlay!.context)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => RechooseriderScreen(
                          idRider: message.data["idRider"],
                          idLivraison: message.data["idLivraison"]),
                    ),
                    (route) => false,
                  );
                }
                if (message.notification!.title.toString() ==
                        "Vous etes arrivé à destination" ||
                    message.notification!.title.toString() ==
                        "Vous etes arrivé à votre derniere destination" ||
                    message.notification!.title.toString() ==
                        "Votre livreur est chez vous") {
                  Navigator.of(navigatorKey.currentState!.overlay!.context)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          RateScreen(idlivraison: message.data["idLivraison"]),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  if (Platform.isAndroid || Platform.isIOS) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Navigator.of(navigatorKey.currentState!.overlay!.context)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Accueille(),
        ),
        (route) => false,
      );
      print("idLivraisonMessage: ${message.data["idLivraison"]}");
      if (message.data["forUser"] == "false") {
        _showAlertDialog(message);
      }
      _showAlertDialog(message);

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    //FirebaseMessaging onBackgroundMessage when app is on background

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then;
    MobileAds.instance.initialize();
  }
  //Firebase open app openup
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("message opened");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (message.notification!.title.toString() !=
              "Vous etes arrivé à destination" &&
          message.notification!.title.toString() !=
              "Votre rider a annulée la course!") {
        Navigator.of(navigatorKey.currentState!.overlay!.context)
            .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                Newmaplive(idLivraison: message.data["idLivraison"]),
          ),
          (route) => false,
        );
      }
      if (message.notification!.title.toString() ==
          "Votre rider a annulée la course!") {
        Navigator.of(navigatorKey.currentState!.overlay!.context)
            .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RechooseriderScreen(
                idRider: message.data["idRider"],
                idLivraison: message.data["idLivraison"]),
          ),
          (route) => false,
        );
      }
      if (message.notification!.title.toString() ==
              "Vous etes arrivé à destination" ||
          message.notification!.title.toString() ==
              "Vous etes arrivé à votre derniere destination" ||
          message.notification!.title.toString() ==
              "Votre livreur est chez vous") {
        Navigator.of(navigatorKey.currentState!.overlay!.context)
            .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                RateScreen(idlivraison: message.data["idLivraison"]),
          ),
          (route) => false,
        );
      }
      // Navigator.of(navigatorKey.currentState!.overlay!.context).push(
      //   MaterialPageRoute(
      //     builder: (context) => DeliveryDetail(
      //         idLivraison: message.data["idLivraison"].toString()),
      //   ),
      // );
    });
  });

  ThemeHelper().changeTheme('primary');
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeliveryData(),
      child: const MyApp(),
    ),
  );
}

class DeliveryData extends ChangeNotifier {
  LatLng? _departLocation;
  LatLng? _deliveryLocation;
  String? _departAddress;
  String? _deliveryAddress;

  String _errorMessage = "";
  bool _isError = false;

  String get errorMessage => _errorMessage;
  bool get isError => _isError;

  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setIsError(bool value) {
    _isError = value;
    notifyListeners();
  }

  LatLng? _departLocationRidee;
  LatLng? _deliveryLocationRidee;
  //List of LatLng
  List<LatLng>? _multipoint;
  List<dynamic>? _multipointAddress;

  String? _departAddressRidee;
  String? _deliveryAddressRidee;

  String? _noteRidee;

  List<dynamic>? _notePackee;

  String? get departAddress => _departAddress;
  String? get deliveryAddress => _deliveryAddress;

  String? get noteRidee => _noteRidee;

  List<dynamic>? get notePackee => _notePackee;

  String? get departAddressRidee => _departAddressRidee;
  String? get deliveryAddressRidee => _deliveryAddressRidee;

  List<LatLng>? get multipoint => _multipoint;
  List<dynamic>? get multipointAddress => _multipointAddress;

  LatLng? get departLocation => _departLocation;
  LatLng? get deliveryLocation => _deliveryLocation;

  LatLng? get departLocationRidee => _departLocationRidee;
  LatLng? get deliveryLocationRidee => _deliveryLocationRidee;

  //function that clear all the attribute of the class
  void clear() {
    _departLocation = null;
    _deliveryLocation = null;
    _departAddress = null;
    _deliveryAddress = null;
    _departLocationRidee = null;
    _deliveryLocationRidee = null;
    _multipoint = null;
    _multipointAddress = null;
    _departAddressRidee = null;
    _deliveryAddressRidee = null;
    _noteRidee = null;
    _notePackee = null;
    notifyListeners();
  }

  void setDepartLocation(LatLng? value) {
    _departLocation = value;
    notifyListeners();
  }

  void setNotePackee(List<dynamic> value) {
    _notePackee = value;
    notifyListeners();
  }

  void setMultipoint(List<LatLng>? value) {
    _multipoint = value;
    notifyListeners();
  }

  void setMultipointAddress(List<dynamic>? value) {
    _multipointAddress = value;
    notifyListeners();
  }

  void setNoteRidee(String? value) {
    _noteRidee = value;
    notifyListeners();
  }

  void setDepartAddress(String? value) {
    _departAddress = value;
    notifyListeners();
  }

  void setDeliveryAddress(String? value) {
    _deliveryAddress = value;
    notifyListeners();
  }

  void setDeliveryLocation(LatLng? value) {
    _deliveryLocation = value;
    notifyListeners();
  }

  void setDepartLocationRidee(LatLng? value) {
    _departLocationRidee = value;
    notifyListeners();
  }

  void setDepartAddressRidee(String? value) {
    _departAddressRidee = value;
    notifyListeners();
  }

  void setDeliveryAddressRidee(String? value) {
    _deliveryAddressRidee = value;
    notifyListeners();
  }

  void setDeliveryLocationRidee(LatLng? value) {
    _deliveryLocationRidee = value;
    notifyListeners();
  }

  Restaurant? _orderingRestaurant;
  Restaurant? get orderingRestaurant => _orderingRestaurant;
  void setOrderingRestaurant(Restaurant? value) {
    _orderingRestaurant = value;
    notifyListeners();
  }

  LatLng? departLocationFoodee;
  String? departAddressFoodee;

  LatLng? getDepartLocationFoodee() => departLocationFoodee;
  String? getDepartAddressFoodee() => departAddressFoodee;

  void setDepartLocationFoodee(LatLng? value) {
    departLocationFoodee = value;
    notifyListeners();
  }

  void setDepartAddressFoodee(String? value) {
    departAddressFoodee = value;
    notifyListeners();
  }

  bool _isFetching = true;
  bool get isFetching => _isFetching;
  void setIsFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  bool _loginIsFetching = false;
  bool get loginIsFetching => _loginIsFetching;
  void setLoginIsFetching(bool value) {
    _loginIsFetching = value;
    notifyListeners();
  }

  bool _myProfileIsFetching = false;
  bool get myProfileIsFetching => _myProfileIsFetching;
  void setMyProfileIsFetching(bool value) {
    _myProfileIsFetching = value;
    notifyListeners();
  }

  bool _myProfileIsEditing = false;
  bool get myProfileIsEditing => _myProfileIsEditing;
  void setMyProfileIsEditing(bool value) {
    _myProfileIsEditing = value;
    notifyListeners();
  }

  UserFire.User? _userFire = null;
  UserFire.User? get userFire => _userFire;
  void setUserFire(UserFire.User? value) async {
    if (value == null) {
      SessionManager().get("user").then((value) {
        UserFire.User user = UserFire.User.fromJson(value);
        _userFire = user;
        notifyListeners();
      });
    } else {
      _userFire = value;
      notifyListeners();
    }
  }

  XFile? _myProfileImage;
  XFile? get myProfileImage => _myProfileImage;
  void setMyProfileImage(XFile myProfileImage) {
    _myProfileImage = myProfileImage;
    notifyListeners();
  }

  void updateUserFire(UserFire.User? value) async {
    _myProfileIsFetching = true;
    notifyListeners();
    final UserRepository userRepository = UserRepository();
    String? currentid = userRepository.getCurrentUser()?.uid;
    userRepository.updateUserById(currentid!, value!);
    _userFire = value;
    _myProfileIsFetching = false;
    notifyListeners();
  }

  double _cartFoodieTotalLocal = 0.0;
  double get cartFoodieTotalLocal => _cartFoodieTotalLocal;
  void setCartFoodieTotalLocal(double value) {
    _cartFoodieTotalLocal = value;
    notifyListeners();
  }

  List<CartFoodeeItem> _cartFoodeeItems = [];
  List<CartFoodeeItem> get cartFoodeeItems => _cartFoodeeItems;
  void setCartFoodeeItems(List<CartFoodeeItem> value) {
    _cartFoodeeItems = value;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale = const Locale("en");

  setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  String _statusText = "Waiting...";
  final String _finished = "Finished creating channel";
  final String _error = "Error while creating channel";

  static const MethodChannel _channel = MethodChannel('customchannel');

  Map<String, String> channelMap = {
    "id": "CHAT_MESSAGES",
    "name": "Chats",
    "description": "Chat notifications",
  };

  void _createNewChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      setState(() {
        _statusText = _finished;
      });
    } on PlatformException catch (e) {
      _statusText = _error;
      print(e);
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale') ?? "en";
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _createNewChannel();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    setState(() {
      _locale = Locale(locale);
    });

    // Location location = new Location();
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // LocationData _locationData;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // _locationData = await location.getLocation();
    // location.enableBackgroundMode(enable: true);
    // location.changeSettings(interval: 10000, distanceFilter: 10);
    // location.onLocationChanged.listen((LocationData currentLocation) {

    //   print("current location : " + currentLocation.toString());
    // });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setupInteractedMessage();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        init();
        print("inited");
        // LivraisonRepository livraisonRepository = LivraisonRepository();
        // await livraisonRepository.getLastLivraisonWithNoRider().then((value) {
        //   print("here in check cancel");
        //   setState(() {
        //     if (value["id"] != "") {
        //       Future.delayed(Duration(milliseconds: 500), () {
        //         Navigator.of(navigatorKey.currentState!.overlay!.context)
        //             .pushAndRemoveUntil(
        //           MaterialPageRoute(
        //             builder: (context) => RechooseriderScreen(
        //               idRider: value["livraison"].idrider!,
        //               idLivraison: value["id"],
        //             ),
        //           ),
        //           (route) => false,
        //         );
        //       });
        //     }
        //   });
        // });
      } catch (e) {
        print("Error in getLastLivraisonWithNoRider: $e");
      } finally {
        // Add any necessary cleanup code here
      }
    });

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    //don't forget to dispose of it when not needed anymore
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do something here
      // LivraisonRepository livraisonRepository = LivraisonRepository();
      // livraisonRepository.getLastLivraisonWithNoRider().then((value) {
      //   setState(() {
      //     if (value["id"] != "") {
      //       //
      //       print("canceled by rider");
      //       //delayed Future 1 second to navigate to the livraison screen
      //       Future.delayed(Duration(milliseconds: 500), () {
      //         Navigator.of(navigatorKey.currentState!.overlay!.context)
      //             .pushAndRemoveUntil(
      //           MaterialPageRoute(
      //             builder: (context) => RechooseriderScreen(
      //                 idRider: value["livraison"].idrider!,
      //                 idLivraison: value["id"]),
      //           ),
      //           (route) => false,
      //         );
      //       });
      //     }
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: theme,
        title: 'Rider Register',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('id'),
        ],
        locale: _locale,
        home: const AccueilScreen(),
      );
    });
  }
}

// class Splash extends StatelessWidget {
//   const Splash({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 0,
//       navigateAfterSeconds: new AccueilScreen(),
//       title: new Text(
//         'L’application qui révolutionne votre routine au quotidien.',
//       ),
//       image: Image.asset('assets/logo/dagologo2.png'),
//       photoSize: 200.0,
//     );
//   }
// }
