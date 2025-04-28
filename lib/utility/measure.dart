String distanceFormatted(double distanceInMeters) {
  String distanceFormatted;
  if (distanceInMeters >= 1000) {
    distanceFormatted = '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
  } else {
    distanceFormatted = '$distanceInMeters m';
  }
  return distanceFormatted;
}
