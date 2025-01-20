import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/local_storage/shared_prefs_service.dart';
import 'package:asteron_x/service/models/leaderboard_model.dart';
import 'package:get/get.dart';
import '../service/leaderboard_service.dart';

class LeaderBoardController extends GetxController {
  var leaderBoardData = Rxn<LeaderBoardModel>();
  var isLoading = false.obs;
  UserController userController = Get.put(UserController());
  Future<void> fetchLeaderBoardData() async {
    isLoading.value = true;

    try {
      // Fetch cached leaderboard data
      final cachedData = await SharedPrefService.getLeaderBoardData();
      if (cachedData != null) {
        leaderBoardData.value = cachedData;
      } else {
        // Fetch new data from API if no valid cache is found
        final newData = await LeaderboardService.fetchLeaderBoardData(
            userController.user.value!.id ?? 0);
        if (newData != null) {
          await SharedPrefService.storeLeaderBoardData(newData);
          leaderBoardData.value = newData;
        }
      }
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      leaderBoardData.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
