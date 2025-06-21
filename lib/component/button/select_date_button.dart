import 'package:flutter/material.dart';
import 'package:protask/theme/text_design.dart';

class SelectDateButton extends StatelessWidget {
  final String label;
  final String dateTime;
  final VoidCallback onPressed;
  const SelectDateButton({
    super.key,
    required this.label,
    required this.dateTime,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextDesign().fieldLabel.copyWith(fontSize: 16)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: Colors.white,
          ),
          child: Text(
            dateTime,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
