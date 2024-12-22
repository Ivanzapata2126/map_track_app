import 'package:hive_flutter/hive_flutter.dart';
part 'zones.g.dart';

@HiveType(typeId: 1)
class Zones extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int radius;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  Zones({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.color
  });
}
