import 'package:asteron_x/service/getx/service/user_service.dart';
import 'package:asteron_x/service/local_storage/shared_prefs_service.dart';
import 'package:asteron_x/service/models/user_model.dart';
import 'package:get/get.dart';

class ManageAuth {
  static Future<void> completeSignIn(UserModel userData) async {
    try {
      await SharedPrefService.storeDada(userData);
    } catch (error) {
      throw Exception('Failed to complete sign-in process');
    }
  }

  static Future<void> logout() async {
    try {
      final String? refreshToken = await SharedPrefService.getRefreshToken();
      if (refreshToken != null) {
        await UserService.logout(refreshToken);
      }
    } catch (e) {
      print('ManageAuth: backend logout failed (continuing local cleanup): $e');
    }
    try {
      await SharedPrefService.removeData();
      Get.offAllNamed('/splash');
    } catch (error) {
      throw Exception('Failed to perform logout');
    }
  }
}
