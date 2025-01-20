import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:asteron_x/widgets/x_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:asteron_x/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController usercontroller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to calculate screen size and margin dynamically
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _header(context),
                  const SizedBox(height: 20),
                  _inputField(context),
                  const SizedBox(height: 20),
                  _forgotPassword(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat'),
        ),
        Text(
          "Enter your credentials to login",
          style: TextStyle(color: greyColor),
        ),
      ],
    );
  }

  _inputField(context) {
    const double inputFieldHeight = 60.0;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username input field
        Container(
            height: inputFieldHeight,
            child: MyTextField(
              controller: emailController,
              hintText: 'email',
              obscureText: false,
              prefixIcon: Icon(Icons.email),
            )),
        const SizedBox(height: 10),
        // Password input field
        Container(
            height: inputFieldHeight,
            child: MyTextField(
              controller: passwordController,
              hintText: 'password',
              obscureText: true,
              prefixIcon: Icon(FontAwesomeIcons.lock),
            )),
        const SizedBox(height: 20),

        Obx(() {
          if (usercontroller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomLoadingIndicator(
                color: loadingColor,
              ),
            );
          }

          return MyButton(
              onTap: () {
                signIn(emailController.text, passwordController.text, context);
              },
              text: 'Login');
        }),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Need Login related help?",
        style: TextStyle(color: textHighlightColor),
      ),
    );
  }

  // Sign-in method that accepts email and password
  void signIn(String email, String password, BuildContext context) {
    if (Validation.isEmpty(email) || Validation.isEmpty(password)) {
      customToast('email or password cannot be empty',
              Icons.question_mark_sharp, errorColor, primaryColor)
          .show(context);
      return;
    }

    if (!Validation.isValidEmail(email)) {
      customToast('Invalid Email Address', Icons.question_mark_sharp,
              errorColor, primaryColor)
          .show(context);
    }

    if (!Validation.isValidPass(password)) {
      customToast('Invalid Password', Icons.question_mark_sharp, errorColor,
              primaryColor)
          .show(context);
      return;
    }

    usercontroller.fetchUser(email, password);
  }
}
