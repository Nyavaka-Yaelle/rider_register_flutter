import 'package:flutter/material.dart';
import 'package:rider_register/repository/notif_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rider_register/screens/newmaplive.dart';
//firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_register/theme/theme_helper.dart';

import '../models/notif.dart';

class NotifsScreen extends StatefulWidget {
  final Function(bool) setIsShowBotNavBar;
  final Function(int) changeTabIndex;

  const NotifsScreen({
    Key? key,
    required this.setIsShowBotNavBar,
    required this.changeTabIndex,
  }) : super(key: key);

  @override
  _NotifsScreenState createState() => _NotifsScreenState();
}

class _NotifsScreenState extends State<NotifsScreen> {
  List<Notif> notifs = [];
  bool isLoading = true;

  Future<void> init() async {
    try {
      NotifRepository notifRepository = NotifRepository();
      String iduser = FirebaseAuth.instance.currentUser!.uid;
      List<Notif> fetchedNotifs = await notifRepository.getNotifsById(iduser);
      setState(() {
        notifs = fetchedNotifs;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() {
        isLoading = false;
      });
      // Handle error as needed (e.g., show an error message to the user)
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the bottom navigation bar
        widget.setIsShowBotNavBar(true);
        // Navigate to the Accueil tab (index 0)
        widget.changeTabIndex(0);
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: scheme.surfaceContainerLowest,
        body: SafeArea(

          child: SingleChildScrollView(
            child: Column(
              children: [
                // height: MediaQuery.of(context).size.height * 0.8,
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height*0.8,
                        child: Center(
                          child: CircularProgressIndicator()
                        )
                      ) // Show a loading indicator while fetching data
                    : notifs.length == 0
                        ? Container(
                          height: MediaQuery.of(context).size.height*0.8,
                          child:
                          Center(child: Text("Aucune notification"))
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notifs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Notif notif = notifs[index];
                              return WidgetNotif(
                                idlivraison: notif.idlivraison,
                                message: notif.text,
                                title: notif.title,
                                fromWhen: notif.fromWhen!,
                                isRead: notif.isRead,
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetNotif extends StatelessWidget {
  final String idlivraison;
  final String message;
  final String title;
  final String fromWhen;
  final bool isRead;
  final Color? bgColor;
  final Color? titleColor;
  final Color? messageColor;

  const WidgetNotif({
    Key? key,
    required this.idlivraison,
    required this.message,
    required this.title,
    required this.fromWhen,
    required this.isRead,
    this.bgColor,
    this.titleColor,
    this.messageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color defaultBgColor = isRead ? Colors.grey[200]! : Colors.blue[100]!;
    Color defaultMessageColor = Colors.black;

    return GestureDetector(
      onTap: () {
        
        // Navigate to a new page or perform the desired action on tap
        // Example: Navigate to a notification details page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                   Newmaplive(idLivraison: idlivraison)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.98,
          decoration: BoxDecoration(
            color: bgColor ?? defaultBgColor,
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
            border: Border.all(color: Colors.blue[300]!, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: titleColor ?? Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                Text(
                  message,
                  style: TextStyle(
                    color: messageColor ?? defaultMessageColor,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                Text(
                  'Reçu: $fromWhen', // Showing "Received:" before the date
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example NotificationDetailsPage
class NotificationDetailsPage extends StatelessWidget {
  final String idlivraison;

  const NotificationDetailsPage(this.idlivraison);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for the notification details page
    // You can use the idCommande to fetch more details about the notification
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Center(
        child: Text('Details for Notification with idCommande: $idlivraison'),
      ),
    );
  }
}