// ignore_for_file: prefer_const_constructors

import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const CustomExpansionTile(
      {super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          initiallyExpanded: title == 'Summary' ? true : false,
          dense: false,
          iconColor: textHighlightColor,
          backgroundColor: Colors
              .transparent, // Set to transparent to remove internal padding
          collapsedIconColor: greyColor,
          textColor: textHighlightColor,
          collapsedTextColor: greyColor,
          title: Text(title),
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: data
                    .map((item) =>
                        _buildRow(item['icon'], item['label'], item['value']))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                size: 14,
                icon,
                color: greyColor,
              ),
              SizedBox(width: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'montserrat',
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textHighlightColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
