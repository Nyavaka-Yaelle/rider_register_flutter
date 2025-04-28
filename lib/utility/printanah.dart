import 'dart:io';

void printanah(String message) {
  final styledMessage = '🌞 \x1B[36;3;1m$message\x1B[0m 🌚';
  print(styledMessage);
}

void printredinios(String message) {
  final styledMessage = '🌞 ===> $message <=== 🌚';
  print(styledMessage);
}

void printend(String message) {
  final styledMessage = '\x1B[34m🌚 $message\x1B[0m';
  print(styledMessage);
}

void printwarn(String message) {
  final styledMessage = '\x1B[33m🌚 $message\x1B[0m';
  print(styledMessage);
}

void printerror(String message) {
  final styledMessage = '\x1B[31;3;1m🤟 $message\x1B[0m';
  print(styledMessage);
}
