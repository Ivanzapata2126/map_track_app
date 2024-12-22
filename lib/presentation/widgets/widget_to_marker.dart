import 'package:flutter/material.dart';
import 'package:map_track_app/config/theme/app_theme.dart';

class WidgetToMarker extends StatelessWidget {
  const WidgetToMarker({super.key, this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return icon == null ? const CircleAvatar(
      minRadius: 20,
      maxRadius: 30,
      foregroundImage: AssetImage('assets/images/logo_person.jpg'),
    ) : Icon(icon,size: 90,color: AppTheme.primaryColor,);
  }
}