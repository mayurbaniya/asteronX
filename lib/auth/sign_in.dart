import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController userController = Get.put(UserController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                _Logo(scheme: scheme),
                const SizedBox(height: 32),
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: tt.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to manage your leads and earnings',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 36),
                MyTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  labelText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Need help?'),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => MyButton(
                      onTap: () => _signIn(context),
                      text: 'Sign in',
                      loading: userController.isLoading.value,
                    )),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: scheme.outlineVariant
                                .withValues(alpha: 0.6))),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Asteron Partner Portal',
                        style: tt.labelSmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            color: scheme.outlineVariant
                                .withValues(alpha: 0.6))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (Validation.isEmpty(email) || Validation.isEmpty(password)) {
      _toast(context, 'Email and password are required');
      return;
    }
    if (!Validation.isValidEmail(email)) {
      _toast(context, 'Invalid email address');
      return;
    }
    if (!Validation.isValidPass(password)) {
      _toast(context, 'Invalid password');
      return;
    }

    userController.fetchUser(email, password);
  }

  void _toast(BuildContext context, String message) {
    final scheme = Theme.of(context).colorScheme;
    customToast(
      message,
      Icons.error_outline_rounded,
      scheme.error,
      scheme.onSurface,
    ).show(context);
  }
}

class _Logo extends StatelessWidget {
  final ColorScheme scheme;
  const _Logo({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.bolt_rounded,
            color: scheme.onPrimaryContainer, size: 38),
      ),
    );
  }
}
