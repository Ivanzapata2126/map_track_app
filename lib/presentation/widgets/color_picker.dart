import 'package:flutter/material.dart';
import 'package:map_track_app/config/theme/app_theme.dart';
import 'package:map_track_app/presentation/providers/map_provider.dart';
import 'package:provider/provider.dart';

class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(AppTheme.colorList.length, (index) {
        final color = AppTheme.colorList[index];
        final isSelected = mapProvider.selectedColor == index;

        return GestureDetector(
          onTap: () {
            mapProvider.changeColorIndex(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(height: 4),
                isSelected
                    ? Container(
                        height: 4,
                        width: 16,
                        color: color,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
