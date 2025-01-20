import 'dart:convert';
import 'dart:io';

import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/service/payment_service.dart';
import 'package:asteron_x/service/models/PaymentModel.dart';
import 'package:asteron_x/utils/constants.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var isEditing = false.obs;
  var paymentDetails = Rxn<PaymentModel>();
  UserController userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    _loadPaymentDetailsFromStorage();
  }

  void toggleEditing() {
    isEditing(!isEditing.value);
  }

  /// Loads payment details from local storage
  Future<void> _loadPaymentDetailsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedPaymentData = prefs.getString(paymentDetailsKey);

    if (cachedPaymentData != null) {
      paymentDetails(PaymentModel.fromJson(jsonDecode(cachedPaymentData)));
    }
  }

  /// Adds payment details with file upload
  void addPaymentDetails(File image, String upiID) async {
    try {
      int partnerID = userController.user.value?.id ?? 0;

      if (partnerID == 0) {
        throw Exception('Invalid Partner ID');
      }

      isLoading(true);

      // Call the service to upload the payment details
      if (isEditing.value) {
        final PaymentModel? paymentModel =
            await PaymentService.updatePaymentDetails(partnerID, upiID, image);

        if (paymentModel != null) {
          // Update the local observable with the uploaded payment details
          paymentDetails(paymentModel);
          _cachePaymentDetails(paymentModel);
          Get.offAndToNamed('/splash');
        } else {
          throw Exception('Failed to upload payment details');
        }
      } else {
        final PaymentModel? paymentModel =
            await PaymentService.addPaymentDetails(partnerID, upiID, image);

        if (paymentModel != null) {
          // Update the local observable with the uploaded payment details
          paymentDetails(paymentModel);
          _cachePaymentDetails(paymentModel);
          Get.offAndToNamed('/splash');
        } else {
          throw Exception('Failed to upload payment details');
        }
      }
    } catch (e) {
      // showCustomCupertinoAlertDialog(
      //   title: 'Error',
      //   message: e.toString(),
      // );
    } finally {
      isLoading(false);
    }
  }

  /// Fetches payment details and caches them
  void getPaymentDetails() async {
    try {
      if (paymentDetails.value != null) {
        // If payment details already exist in memory, do not fetch again
        return;
      }

      isLoading(true);

      int partnerID = userController.user.value?.id ?? 0;

      if (partnerID == 0) {
        throw Exception('Invalid Partner ID');
      }

      final PaymentModel? paymentModel =
          await PaymentService.getPaymentDetails(partnerID);

      if (paymentModel != null) {
        paymentDetails(paymentModel);
        _cachePaymentDetails(paymentModel);
      } else {
        throw Exception('Failed to fetch payment details');
      }
    } catch (e) {
      showCustomCupertinoAlertDialog(
        title: 'Error',
        message: e.toString(),
      );
    } finally {
      isLoading(false);
    }
  }

  /// Caches payment details locally
  Future<void> _cachePaymentDetails(PaymentModel paymentModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(paymentDetailsKey, jsonEncode(paymentModel.toJson()));
  }
}
