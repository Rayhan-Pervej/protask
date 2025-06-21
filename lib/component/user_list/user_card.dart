import 'package:flutter/material.dart';
import 'package:protask/component/user_list/user_avater.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class UserCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String position;
  final String email;
  final VoidCallback onTap;
  const UserCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: MyColor.white,
      child: ListTile(
        leading: UserAvatar(avatarUrl: avatarUrl),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextDesign().bodyText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              position,
              style: TextDesign().bodyText.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        subtitle: Text(email, style: TextDesign().bodyText),
        onTap: onTap,
      ),
    );
  }
}
