import 'dart:io';

import 'package:flutter/material.dart';

import '../models/commande.dart';

class foodeeOrderStatus extends StatefulWidget {
  const foodeeOrderStatus({super.key});
  @override
  State<foodeeOrderStatus> createState() => _foodeeOrderStatusState();
}

class _foodeeOrderStatusState extends State<foodeeOrderStatus> {
  int _status = 1;

  Future<void> init() async {
    setState(() {
      _status = 1;
    });
    await new Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status = 2;
    });
    await new Future.delayed(const Duration(seconds: 2));
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => init(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              _status == 2
                                  ? 'assets/logo/foodee attente de confirmation.png'
                                  : 'assets/logo/foodee en cours de traitement.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      if (_status == 1)
                        Text("Attente de confirmation restaurant"),
                      if (_status == 2) Text("En cours de traitement"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: WidgetEMoney(
      //   cartFoodieTotalLocal: _cartFoodieTotalLocal,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
