import 'package:rider_register/utility/printanah.dart';

String formatPhoneNumber(String phoneNumber) {
  return phoneNumber.replaceAllMapped(
      RegExp(r'(\d{3})(\d{2})(\d{2})(\d{3})(\d{2})'), (match) {
    return '${match[1]} ${match[2]} ${match[3]} ${match[4]} ${match[5]}';
  });
}

String formatPhoneNumStars(String phoneNumber) {
  if (phoneNumber.startsWith('+261') && phoneNumber.length == 13) {
    String formattedNumber = '+261 XX XX X' +
        phoneNumber.substring(9, 11) +
        ' ' +
        phoneNumber.substring(11);
    return formattedNumber;
  } else {
    return phoneNumber;
  }
}
