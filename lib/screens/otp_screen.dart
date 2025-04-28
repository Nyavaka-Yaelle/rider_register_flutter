import 'package:flutter/material.dart';
import '../components/opt_input_field.dart';
import '../components/custom_button.dart';
import '../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './new_password.dart';
import '../services/TwilioService.dart';

class OtpScreen extends StatefulWidget {
  final bool isvalidate;
  final String numero;
  final String verificationId;

  const OtpScreen({
    Key? key,
    this.isvalidate = false, // Valeur par défaut
    this.numero = '', // Valeur par défaut
    this.verificationId = '', // Valeur par défaut
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final ScrollController _scrollController = ScrollController();
  Color appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest;
  bool isButtonEnabled = false; // Pour activer/désactiver le bouton
  String _code = '';
  final TwilioService twilioService = TwilioService();

   void _onOtpComplete(String otpValue) {
    setState(() {
      _code = otpValue;
    });
  }

  void _verifyCode() async {
    print('Code: $_code');
    bool otpVerified = await twilioService.verifyOtp(widget.numero, _code);

    if (otpVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewPassword(
            numero: widget.numero,
          ),
        ),
      );
    } else {
      // Handle OTP verification failure
      print('Failed to verify OTP');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP')),
      );
    }
  }
  
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

  String getNumero() {
    String visiblePart = widget.numero.isNotEmpty
        ? widget.numero.substring(1, widget.numero.length)
        : '32 00 123 45'; // Partie visible
    return '+ 261 ' + visiblePart;
  }

  String hintNumero() {
    String visiblePart = widget.numero.isNotEmpty
        ? widget.numero.substring(1, widget.numero.length - 9)
        : '32 '; // Partie visible
    String hiddenPart = '** *** **'; // Partie masquée
    return '+ 261 ' + visiblePart + hiddenPart;
  }

  // Fonction qui sera appelée pour mettre à jour l'état du bouton
  void _updateButtonState(bool areAllFieldsFilled) {
    setState(() {
      isButtonEnabled = areAllFieldsFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: appBarColor,
        title: const Text('Vérification'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isvalidate) ...[
                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/check_circle.png',
                    height: 64.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Votre numéro a été bien validé',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: MaterialTheme.lightScheme().secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    getNumero(),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: MaterialTheme.lightScheme().onSurface,
                    ),
                  ),
                ),
              ],
              if (!widget.isvalidate) ...[
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Un code a été envoyé au numéro',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: MaterialTheme.lightScheme().secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    hintNumero(),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: MaterialTheme.lightScheme().onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Composant OTP
                OtpInputField(
                  length: 6, // Nombre de champs
                  onChanged: _updateButtonState, 
                  onOtpComplete: _onOtpComplete,
// Callback pour notifier la mère
                ),
                const SizedBox(height: 56.0),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomButton(
                    label: "Valider",
                    isDisabled: !isButtonEnabled,
                    onPressed: isButtonEnabled
                        ? _verifyCode
                        : null, // Si isButtonEnabled est false, on désactive le bouton (null)
                    color: MaterialTheme.lightScheme().primary,
                  )
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                  onTap: () {
                    // Action à effectuer lors du clic
                    print('Renvoyer le code !');
                  },
                  child: Text(
                    'Renvoyez le code ?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: MaterialTheme.lightScheme().primary,
                    ),
                  ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}