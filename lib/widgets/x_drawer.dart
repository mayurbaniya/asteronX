// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:asteron_x/service/getx/helper/manage_auth.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  String _userName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'Guest';
      _email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor,
            border: Border(right: BorderSide(color: Colors.grey, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          width: 100,
                          height: 100,
                          image: AssetImage(profileIMG),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(color: bgColor),
                    accountName: Text(
                      _userName,
                      style: TextStyle(color: textPrimaryColor),
                    ),
                    accountEmail: Text(
                      _email,
                      style: TextStyle(color: textPrimaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuItem(
                      icon: Icons.info,
                      text: 'About',
                      onTap: () {
                        // Navigate to About page
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuItem(
                      icon: Icons.contact_mail,
                      text: 'Contact',
                      onTap: () {
                        // Navigate to Contact page
                        Navigator.pushNamed(context, '/contact');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuItem(
                      icon: Icons.help,
                      text: 'Policies',
                      onTap: () {
                        // Navigate to Help page
                        Navigator.pushNamed(context, '/policies');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sign out?',
                    style: TextStyle(color: primaryColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_sharp, color: primaryColor),
                    onPressed: () {
                      ManageAuth.logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          // borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 16, top: 16, bottom: 16),
              child: Icon(
                icon,
                color: greyColor,
              ),
            ),
            Text(
              text,
              style: TextStyle(color: textPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
