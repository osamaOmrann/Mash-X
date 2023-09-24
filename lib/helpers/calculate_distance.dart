import 'dart:math';

double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2) {
  const double earthRadius =
  6371; // in kilometers

  double toRadians(double degree) {
    return degree * pi / 180;
  }

  double dLat = toRadians(lat2 - lat1);
  double dLon = toRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(toRadians(lat1)) *
          cos(toRadians(lat2)) *
          pow(sin(dLon / 2), 2);
  double c =
      2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;
  return distance;
}