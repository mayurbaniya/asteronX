import 'package:asteron_x/service/local_storage/shared_prefs_service.dart';
import 'package:asteron_x/service/models/user_model.dart';
import 'package:get/get.dart';

class ManageAuth {
  static void completeSignIn(UserModel userData) {
    try {
      SharedPrefService.storeDada(userData);
    } catch (error) {
      throw Exception('Failed to complete sign-in process');
    }
  }

  static void logout() {
    try {
      SharedPrefService.removeData();
      Get.toNamed('/splash');
    } catch (error) {
      throw Exception('Failed to perform logout');
    }
  }
}
