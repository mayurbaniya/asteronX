import 'package:asteron_x/auth/sign_in.dart';
import 'package:asteron_x/maintenance.dart';
import 'package:asteron_x/pages/app/about.dart';
import 'package:asteron_x/pages/app/contact.dart';
import 'package:asteron_x/pages/app/policies.dart';
import 'package:asteron_x/pages/home.dart';
import 'package:asteron_x/pages/lead_details.dart';
import 'package:asteron_x/pages/my_leads.dart';
import 'package:asteron_x/splash.dart';
import 'package:get/get.dart';

class Routes {
  static final routes = [
    GetPage(
        name: '/splash',
        page: () => Splash(),
        transition: Transition.cupertino),
    GetPage(
        name: '/maintanence',
        page: () => Maintenance(),
        transition: Transition.cupertino),
    GetPage(
        name: '/home',
        page: () => HomeScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: '/login',
        page: () => LoginPage(),
        transition: Transition.cupertino),
    GetPage(
        name: '/my-leads',
        page: () => MyLeads(),
        transition: Transition.cupertino),
    GetPage(
        name: '/details',
        page: () => LeadDetails(),
        transition: Transition.cupertino),
    GetPage(
        name: '/about',
        page: () => AboutPage(),
        transition: Transition.cupertino),
    GetPage(
        name: '/contact',
        page: () => Contact(),
        transition: Transition.cupertino),
    GetPage(
        name: '/policies',
        page: () => PoliciesPage(),
        transition: Transition.cupertino),
  ];
}
