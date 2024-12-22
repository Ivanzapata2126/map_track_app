import 'package:geolocator/geolocator.dart';

class CustomLocation {
  Position position;
  LocationPermission locationPermission;

  CustomLocation(this.position, this.locationPermission);
}