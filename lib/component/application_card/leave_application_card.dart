import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class LeaveApplicationCard extends StatelessWidget {
  final String subject;
  final String sentDate;
  final String appoveDate;
  final String status;
  final String description;
  final VoidCallback onTap;
  const LeaveApplicationCard({
    super.key,
    required this.subject,
    required this.appoveDate,
    required this.sentDate,
    required this.status,
    required this.description,
    required this.onTap,
  });
  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM").format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: MyColor.gray,
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject, style: TextDesign().taskName.copyWith(fontSize: 16)),
            const SizedBox(height: 8),

            Text(
              description,
              style: TextDesign().bodyText.copyWith(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: MyColor.darkBlue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Status: $status",
                      style: TextDesign().bodyText.copyWith(
                        color: MyColor.darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.envelopeCircleCheck,
                      size: 16,
                      color: MyColor.softBlue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatDate(sentDate),
                      style:  TextStyle(
                        fontSize: 12,
                        color: MyColor.softBlue,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                     Icon(
                      FontAwesomeIcons.thumbsUp,
                      size: 16,
                      color: MyColor.softBlue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      formatDate(appoveDate),
                      style:  TextStyle(
                        fontSize: 12,
                        color: MyColor.softBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
