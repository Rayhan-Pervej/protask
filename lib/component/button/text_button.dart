import 'package:flutter/material.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class CustomTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const CustomTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: MyColor.softBlue,
        iconColor: MyColor.black,
        overlayColor: MyColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextDesign().bodyText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 0,
              color: MyColor.white,
            ),
          ),
          Icon(icon, size: 15, color: MyColor.white),
        ],
      ),
    );
  }
}
