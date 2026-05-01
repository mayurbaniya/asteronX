import 'package:asteron_x/service/getx/helper/manage_auth.dart';
import 'package:asteron_x/service/getx/service/user_service.dart';
import 'package:asteron_x/service/models/user_model.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  /// Defers the dialog to the next frame so it never opens while a parent
  /// widget is mid-deactivation (which trips '_dependents.isEmpty').
  void _safeAlert(String title, String message) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showCustomCupertinoAlertDialog(title: title, message: message);
    });
  }

  void fetchUser(String email, String password) async {
    try {
      isLoading(true);
      UserModel? fetchedUser = await UserService.fetchUser(email, password);

      if (fetchedUser != null) {
        user.value = fetchedUser;
        await ManageAuth.completeSignIn(fetchedUser);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      _safeAlert('Sign-in failed', '$e');
    } finally {
      isLoading(false);
    }
  }

  void getUserDataFromSF() async {
    try {
      isLoading(true);
      UserModel? fetchedUser = await UserService.getUserDataFromSF();
      if (fetchedUser != null) {
        user.value = fetchedUser;
      }
    } catch (e) {
      _safeAlert('Error', '$e');
    } finally {
      isLoading(false);
    }
  }
}
