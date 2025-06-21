import 'package:flutter/material.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class StatusMenuButton extends StatelessWidget {
  final String status;
  final String selectedStatus;
  final VoidCallback onPressed;

  const StatusMenuButton({
    super.key,
    required this.status,
    required this.selectedStatus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: MyColor.black,
        textStyle: TextDesign().buttonText.copyWith(fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: selectedStatus == status ? MyColor.yellow : MyColor.gray,
        foregroundColor: Colors.white,
      ),
      child: Text(status),
    );
  }
}
