import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

// Future<File> compressImage(File originalFile) async {
//   final img.Image? image = img.decodeImage(originalFile.readAsBytesSync());

//   if (image != null) {
//     int quality = 90;
//     List<int> compressedBytes;
//     File compressedImage;

//     do {
//       compressedBytes = img.encodeJpg(image, quality: quality);
//       compressedImage = File('${originalFile.path}_compressed.jpg')
//         ..writeAsBytesSync(compressedBytes);
//       quality -= 5;
//     } while (compressedImage.lengthSync() > 200 && quality > 0);

//     return compressedImage;
//   } else {
//     throw Exception('Échec de la lecture de l\'image');
//   }
// }

Future<File> compressImage(File originalFile) async {
  final img.Image? image = img.decodeImage(originalFile.readAsBytesSync());

  if (image != null) {
    // Rogner l'image pour en faire un carré
    final int minDimension =
        image.width < image.height ? image.width : image.height;
    final img.Image croppedImage = img.copyCrop(
      image,
      x: (image.width - minDimension) ~/ 2, // Centrer horizontalement
      y: (image.height - minDimension) ~/ 2, // Centrer verticalement
      width: minDimension, // Taille du carré
      height: minDimension,
    );

    // Redimensionner l'image à 200x200 pixels
    final img.Image resizedImage =
        img.copyResize(croppedImage, width: 250, height: 250);

    // Compresser l'image pour qu'elle atteigne environ 100 Ko
    int quality = 90;
    List<int> compressedBytes;
    File compressedImage;

    // Compresser jusqu'à atteindre 100 Ko
    do {
      compressedBytes = img.encodeJpg(resizedImage, quality: quality);
      compressedImage = File('${originalFile.path}_compressed.jpg')
        ..writeAsBytesSync(compressedBytes);

      // Réduire la qualité
      quality -= 5;
    } while (compressedImage.lengthSync() > 150 * 1024 && quality > 0);

    return compressedImage;
  } else {
    throw Exception('Échec de la lecture de l\'image');
  }
}

Future<File> compressIt(File originalFile) async {
  // return await compute(compressImage(originalFile), originalFile);
  return await compute<File, File>(compressImage, originalFile);
}
