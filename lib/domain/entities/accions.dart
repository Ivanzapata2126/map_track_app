import 'package:hive_flutter/hive_flutter.dart';

part 'accions.g.dart';


@HiveType(typeId: 0)
class Accions extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? imagePath;

  @HiveField(4)
  final int? markerIcon;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  Accions({
    required this.title,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.description,
    this.imagePath,
    this.markerIcon,
  });
}
