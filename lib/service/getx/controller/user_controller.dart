import 'package:asteron_x/service/getx/helper/manage_auth.dart';
import 'package:asteron_x/service/getx/service/user_service.dart';
import 'package:asteron_x/service/models/user_model.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  void fetchUser(String email, String password) async {
    try {
      isLoading(true);
      UserModel? fetchedUser = await UserService.fetchUser(email, password);

      if (fetchedUser != null) {
        user.value = fetchedUser;
        ManageAuth.completeSignIn(fetchedUser);
        // UserService.saveFCMToken(user.value!.id.toString());
        Get.offAllNamed('/home');
      }
    } catch (e) {
      showCustomCupertinoAlertDialog(title: 'Error', message: '$e');
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
      showCustomCupertinoAlertDialog(title: 'Error', message: '$e');
    } finally {
      isLoading(false);
    }
  }
}
