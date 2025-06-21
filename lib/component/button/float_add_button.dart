import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';

class FloatAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  const FloatAddButton({
    required this.onPressed,
    this.icon = FontAwesomeIcons.plus,
    this.backgroundColor = MyColor.darkBlue,
    this.iconColor = MyColor.white,
    this.iconSize = 28,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
