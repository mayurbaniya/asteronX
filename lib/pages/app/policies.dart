import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/material.dart';

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Partner Policies',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'montserrat'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                'Welcome to the Partner Policies page. As a partner of Asteron Vehicles, we expect you to follow these guidelines to maintain a smooth and professional relationship. Please read them carefully.',
                style: TextStyle(color: greyColor),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('1. Lead Ownership and Responsibility',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                'You are responsible for the leads you submit. You must not submit leads that are owned by the showroom or obtained from unauthorized sources. If any lead is found to be invalid or stolen from the showroom, you will be held responsible for any legal consequences.',
                style: TextStyle(color: greyColor),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('2. Payment Verification',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                'You are required to verify your payment details daily. If your payment details are incorrect, and we pay your earnings to the wrong account, we will not be held responsible for any losses.',
                style: TextStyle(color: greyColor),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('3. Invalid Leads and Account Suspension',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                'If you are found submitting invalid leads multiple times, your account may be suspended. We take invalid lead submissions seriously and expect honesty in all transactions.',
                style: TextStyle(color: greyColor),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('4. Server Load and Account Suspension',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                "If it is found that you are putting additional load on the server or violating our system's usage policies, your account may be suspended immediately to ensure the stability of our services.",
                style: TextStyle(color: greyColor),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('5. Legal Consequences for Violation',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                'You agreed to these policies when creating your account. Any violation of these terms will be treated seriously, and you will be held accountable for any legal consequences that may arise.',
                style: TextStyle(color: greyColor),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: Row(
                children: [
                  Text(
                    'For any inquiries or clarifications, please contact us at\n\n ${RemoteData().adminEmail}',
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
