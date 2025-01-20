import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/material.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 50),
            const SizedBox(height: 20),
            const Text(
              'App is Under Maintenance!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: const Text(
                'Contact us for more details.',
                style: TextStyle(fontSize: 12, color: textHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
