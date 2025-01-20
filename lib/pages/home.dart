import 'package:asteron_x/pages/add_leads.dart';
import 'package:asteron_x/pages/leaderboard.dart';
import 'package:asteron_x/pages/my_leads.dart';
import 'package:asteron_x/pages/payment_details.dart';
import 'package:asteron_x/pages/payment_history.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/widgets/x_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  UserController userController = Get.put(UserController(), permanent: true);

  int currentIndex = 2;

  // Declare _screens list as late, so it will be initialized later
  late List<Widget> _screens;

  // Method to update the tab
  void _changeTabToMyLeads() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    userController.getUserDataFromSF();

    _screens = [
      MyLeads(),
      PaymentDetails(),
      Leaderboard(),
      AddLeads(onLeadSubmitted: _changeTabToMyLeads),
      PaymentHistory()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
          color: textPrimaryColor,
        ),
      ),
      drawer: CustomSideBar(),
      backgroundColor: bgColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SalomonBottomBar(
          curve: Curves.decelerate,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              activeIcon: Icon(Icons.pending_sharp),
              selectedColor: Colors.redAccent,
              unselectedColor: greyColor,
              icon: Icon(Icons.pending_actions_outlined),
              title: Text(''),
            ),
            SalomonBottomBarItem(
              activeIcon: Icon(FontAwesomeIcons.wallet),
              selectedColor: Colors.blue,
              unselectedColor: greyColor,
              icon: Icon(FontAwesomeIcons.wallet),
              title: Text(''),
            ),
            SalomonBottomBarItem(
              activeIcon: Icon(Icons.home),
              selectedColor: Colors.green,
              unselectedColor: greyColor,
              icon: Icon(Icons.home),
              title: Text(''),
            ),
            SalomonBottomBarItem(
              activeIcon: Icon(Icons.sell),
              selectedColor: Colors.redAccent,
              unselectedColor: greyColor,
              icon: Icon(Icons.sell_sharp),
              title: Text(''),
            ),
            SalomonBottomBarItem(
              activeIcon: Icon(Icons.history_sharp),
              selectedColor: Colors.deepPurpleAccent,
              unselectedColor: greyColor,
              icon: Icon(Icons.history),
              title: Text(''),
            ),
          ],
        ),
      ),
      body: _screens[currentIndex],
    );
  }
}
