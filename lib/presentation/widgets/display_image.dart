import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key, required this.imagePath, required this.onPressed});

  final String? imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return FocusedMenuHolder(
        menuWidth: 90,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(title: const Text('Borrar'), onPressed: () => onPressed())
        ],
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            height: 200,
            child: Image.file(File(imagePath!)),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}