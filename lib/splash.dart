import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/service/getx/controller/payment_controller.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  UserController userController = Get.put(UserController());
  PaymentController paymentController = Get.put(
    PaymentController(),
  );

  void navigator() async {
    await Future.delayed(Duration(milliseconds: 1500));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool('loggedIn');

    print('maint : ${RemoteData().underMaintanence}');

    if (RemoteData().underMaintanence != 'true') {
      if (loggedIn != null) {
        if (loggedIn) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/login');
        }
      } else {
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/maintanence');
    }
  }

  @override
  void initState() {
    super.initState();
    navigator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: CustomLoadingIndicator(
          color: loadingColor,
        ),
      ),
    );
  }
}
