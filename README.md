# RIDEE-WEB
PRIMAIRE	: 	#00AD9C	
SECONDAIRE	:	#2699A7	#FFC001	#F93E2B
FOND		:	#6B6E72	#FFFFFF

# flutter gen-l10n

# layout

https:\\flutteragency.com/how-to-set-space-between-elements-in-flutter/

# setstate

https://stackoverflow.com/a/65540408/11037032

# run on mac
export PATH="$PATH:/Users/anah/Documents/flutter/bin"
open -a Simulator
cd ios
pod repo update
pod update Firebase/Database
pod install
cd ..
flutter pub get
flutter run --no-sound-null-safety --enable-software-rendering
flutter run --release


# build
keytool -genkey -v -keystore \Users\anah\Documents\rider_register_flutter_app\keystore\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
pass: 123456

flutter build appbundle --no-tree-shake-icons --no-sound-null-safety --split-debug-info

<!-- 
        383589416
        38 35 89 41 6
        123456 
-->

# test verify_otp :
38 317 02 05
otp : 123 456
supprimer l'utilisateur correspondant : ao aminy Firebase - Authentification - Users sy Firebase Database - Collection Users

S4ng4tr4h4si4

348638730
AB1152IG

# Unused dart/assets

 - https://marketplace.visualstudio.com/items?itemName=esentis.flutter-find-unused-assets-and-dart-files
 - ctrl + shift + p -> Flutter: Find Unused Dart/Assets

 - flutter pub add delete_un_used_assets
 - flutter pub run delete_un_used_assets:start /assets


rm pubspec.lock
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm ios/Flutter/Flutter.podspec
flutter clean
flutter pub get
cd ios
pod repo update
pod update Firebase/Database
pod update Firebase/Auth
pod update Firebase/Storage
pod update Firebase/AppCheck
pod install
cd ..
flutter pub get
flutter build ios --no-tree-shake-icons --no-sound-null-safety
flutter run --no-sound-null-safety --enable-software-rendering

flutter pub run flutter_launcher_icons:main