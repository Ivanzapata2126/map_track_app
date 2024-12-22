import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    required this.height,
    this.widget,
    this.angle = 0,
    this.backgroundColor,
    required this.thirdWidget,
    required this.firtsWidget,
    required this.secondWidget,
    this.iconAction,
    this.leftArrow = false,
    this.left,
    this.leave,
  });

  final String? title;
  final double height;
  final double angle;
  final Color? backgroundColor;
  final Widget? widget;
  final Widget firtsWidget;
  final Widget thirdWidget;
  final Widget secondWidget;
  final IconButton? iconAction;
  final bool leftArrow;
  final Widget? left;
  final Widget? leave;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text("Map Track", style: Theme.of(context).textTheme.titleMedium,),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              secondWidget,
              const SizedBox(width: 10,),
              firtsWidget,
              const SizedBox(width: 10,),
              thirdWidget,
            ],
          ),
        )
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}