import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
          ),
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _header(),
                const SizedBox(height: 20),
                _description(),
                const SizedBox(height: 20),
                _mission(),
                const SizedBox(height: 20),
                _contact(),
              ],
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
            "Simplifying your vehicle buying experience.",
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

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: const Text(
        "Asteron Vehicles is your trusted vehicle dealer in Nagpur. We help customers buy both new and used vehicles from any showroom in the city. Our mission is to simplify the vehicle buying process, making it more convenient and transparent for you.\n\n"
        "With our easy-to-use app, just search for your desired vehicle, click on the 'Interested' button, and our team will handle the rest, guiding you from selecting your vehicle to receiving the vehicle's number plate. We take care of all the documentation and ensure a smooth experience for you.",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: greyColor,
        ),
      ),
    );
  }

  Widget _mission() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Our Mission",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat',
            ),
          ),
          SizedBox(height: 10),
          Text(
            "To simplify the vehicle buying process for customers, bridging the gap between showrooms and buyers. We aim to create a layer that protects our customers from aggressive showroom marketing while ensuring they receive the best deals.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat',
            ),
          ),
          SizedBox(height: 10),
          Text(
            "For inquiries, feedback, or support, please reach out to us at:\n\n${RemoteData().adminEmail}\n00000 00000",
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
}
