import 'package:asteron_x/firebase_options.dart';
import 'package:asteron_x/routes.dart';
import 'package:asteron_x/service/firebase/remote_config_service.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  UserController userController = Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    userController.getUserDataFromSF();
    await RemoteConfigService().fetchAndSaveConfig();
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // print('FCM token: $fcmToken');

    // FirebaseMessaging.instance.subscribeToTopic('all');
    // print('Subscribed to topic: all');

    runApp(const MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: Routes.routes,
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 20),
                const Text(
                  'Error initializing Firebase!',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        ));
  }
}
