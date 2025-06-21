import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart'; // Ensure this file exists

class Snackbar {
  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void successSnackbar(BuildContext context,
      {required String title, String message = '', required IconData icon}) {
    showSnackbar(
      context,
      title: title,
      message: message,
      backgroundColor: MyColor.softBlue,
      icon: icon,
      textColor: MyColor.white,
    );
  }

  static void warningSnackbar(
    BuildContext context, {
    required String title,
    String message = '',
  }) {
    showSnackbar(
      context,
      title: title,
      message: message,
      backgroundColor: MyColor.red,
      icon: FontAwesomeIcons.triangleExclamation,
      textColor: MyColor.white,
    );
  }

  static void errorSnackbar(
    BuildContext context, {
    required String title,
    String message = '',
  }) {
    showSnackbar(
      context,
      title: title,
      message: message,
      backgroundColor: MyColor.red,
      icon: FontAwesomeIcons.triangleExclamation,
      textColor: MyColor.white,
    );
  }

  static void showSnackbar(
    BuildContext context, {
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$title\n",
                      style: TextDesign().snackBar.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: message,
                      style: TextDesign().snackBar.copyWith(color: textColor, fontWeight:FontWeight.normal),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        
        margin: const EdgeInsets.all(20),
        
      ),

    );
  }
}
