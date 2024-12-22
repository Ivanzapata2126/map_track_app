import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_track_app/domain/entities/custom_location.dart';

abstract class PositionService {
  Future<CustomLocation> getPosition();
  double haversineDistance(LatLng player1, LatLng player2);
}