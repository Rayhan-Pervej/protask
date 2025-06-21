import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.avatarUrl, this.radius = 30});
  final String avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: (avatarUrl.isNotEmpty && avatarUrl.startsWith("http"))
          ? NetworkImage(avatarUrl) as ImageProvider
          : null, // Null means no image
      child: (avatarUrl.isEmpty || !avatarUrl.startsWith("http"))
          ? Icon(Icons.person, size: radius, color: Colors.grey) // Show an icon if no image
          : null,
    );
  }
}
