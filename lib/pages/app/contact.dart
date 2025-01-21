import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _header(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: _contactInfo(),
                  ),
                  const SizedBox(height: 20),
                  _contactForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Text(
          "Asteron Vehicles",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            fontFamily: 'montserrat',
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "We're here to help you. Reach out to us with any queries.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _contactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Information",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "For inquiries, feedback, or assistance, you can reach us through the following channels:\n\n"
            "Email: ${RemoteData().adminEmail}\n"
            "Phone: 00000 00000\n\n"
            "We will respond to your inquiries promptly.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: const Text(
            "Send Us a Message",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat',
            ),
          ),
        ),
        const SizedBox(height: 10),
        MyTextField(
            controller: nameController,
            hintText: 'Your Name',
            obscureText: false),
        const SizedBox(height: 15),
        MyTextField(
            controller: mailController,
            hintText: 'Your Email',
            obscureText: false),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CupertinoTextField(
            placeholder: 'Your Message',
            padding: const EdgeInsets.all(16.0),
            style: const TextStyle(fontSize: 16),
            maxLines: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CupertinoColors.systemGrey6,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: CupertinoButton(
            child: const Text('Send Message'),
            onPressed: () {
              // Handle form submission logic
            },
          ),
        ),
      ],
    );
  }
}
