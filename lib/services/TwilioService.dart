import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'AC8d656ccc0d2d0cbb43135026aba88d6d';
  final String authToken = '810361a3c54c6a4199493e8449d29a12';
  final String serviceId = 'VA2c12463692538d06ed1664adb0c3b60c';

  Future<bool> sendOtp(String toNumber , String channel) async {
    final String url = 'https://verify.twilio.com/v2/Services/$serviceId/Verifications';
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'To': toNumber,
        'Channel': channel,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      print('OTP sent successfully');
    } else {
        return false;
      print('Failed to send OTP: ${response.body}');
    }
  }

  
  Future<bool> verifyOtp(String toNumber, String code) async {
    final String url = 'https://verify.twilio.com/v2/Services/$serviceId/VerificationCheck';
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'To': toNumber,
        'Code': code,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == 'approved') {
        print('OTP verified successfully');
        return true;
      } else {
        print('OTP verification failed: ${responseBody['status']}');
        return false;
      }
    } else {
      print('Failed to verify OTP: ${response.body}');
      return false;
    }
  }

}