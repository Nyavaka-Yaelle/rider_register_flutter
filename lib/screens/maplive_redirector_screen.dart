import 'package:flutter/material.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/screens/foodee_order_status.dart';
import 'package:rider_register/screens/newmaplive.dart';
import 'package:rider_register/screens/pending_approval_ridee.dart';
import 'package:rider_register/screens/pending_approval_screen.dart';
import 'package:flutter/src/widgets/framework.dart';

class MapliveredirectorScreen extends StatefulWidget {
  final String idLivraison;
  final String type;
  MapliveredirectorScreen({required this.idLivraison, required this.type});

  @override
  _MapliveredirectorScreenState createState() =>
      _MapliveredirectorScreenState();
}

class _MapliveredirectorScreenState extends State<MapliveredirectorScreen> {
  bool condition = true;
  @override
  void initState() {
    //Widget post call frameback
    LivraisonRepository livraisonRepository = LivraisonRepository();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      //Get the data from the repository
      Livraison? livraison =
          await livraisonRepository.getLivraisonById(widget.idLivraison);
      //Check if the data is null
      if (livraison != null) {
        //Check if the data is approved
        if (livraison.statut != "Created") {
          Future.delayed(Duration(milliseconds: 500), () {
            //Navigate to the pending approval screen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Newmaplive(
                          idLivraison: widget.idLivraison,
                        )));
          });
        } else {
          //Futuer delayed milliseconds 500
          Future.delayed(Duration(milliseconds: 500), () {
            //Navigate to the pending approval screen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.type == "fodee"
                        ? foodeeOrderStatus()
                        : PendingApprovalRidee()));
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Screen'),
        ),
        body: Center(
          child: Text('Go to Screen'),
        ));
  }
}
