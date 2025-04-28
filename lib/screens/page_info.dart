import 'package:flutter/material.dart';
import '../components/connexion_button.dart';
import '../components/ridee_info.dart';
import '../components/caree_info.dart';
import '../components/packee_info.dart';
import '../components/foodee_info.dart';
import '../theme.dart';

class PageInfo extends StatefulWidget {
  final int idService;

  const PageInfo({
    Key? key,
    this.idService = 1, // Valeur par défaut
  }) : super(key: key);

  @override
  _PageInfoState createState() => _PageInfoState();
}

class _PageInfoState extends State<PageInfo> {
  final ScrollController _scrollController = ScrollController();
  Color appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest;
  Color bodyColor = MaterialTheme.lightScheme().surfaceContainerLowest;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      appBarColor = _scrollController.offset > 50
          ? MaterialTheme.lightScheme().surfaceContainerLowest
          : MaterialTheme.lightScheme().surfaceContainerLowest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bodyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24.0,
            color: MaterialTheme.lightScheme().onSurfaceVariant,
          ), // Flèche "Retour"
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: appBarColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                   if(widget.idService==0) RideeInfo(),
                    if(widget.idService==1) CareeInfo(),
                    if(widget.idService==2) FoodeeInfo(),
                    if(widget.idService==3) PackeeInfo(),
            SizedBox(height: 20), // Optional: Add spacing if needed
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ConnexionButton(),
        ),
      ),
    );
  }
}