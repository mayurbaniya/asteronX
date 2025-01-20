import 'dart:io';

import 'package:asteron_x/service/firebase/remote_data.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/service/models/PaymentModel.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asteron_x/service/getx/controller/payment_controller.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final PaymentController paymentController = Get.put(PaymentController());
  File? image;
  TextEditingController upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    paymentController.getPaymentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        if (paymentController.isLoading.value) {
          return Center(child: CustomLoadingIndicator(color: loadingColor));
        }

        if (paymentController.paymentDetails.value != null) {
          return _renderPaymentDetails(paymentController.paymentDetails.value!);
        }

        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _header(context),
                _addOrUpdatePaymentView(context, isUpdating: false),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          "Payment Details",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            fontFamily: 'montserrat',
          ),
        ),
        const Text(
          "Note: daily verify your payment details \nif details are not correct please contact \nAsteron Support team*",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyColor,
          ),
        ),
      ],
    );
  }

  Widget _addOrUpdatePaymentView(BuildContext context,
      {required bool isUpdating}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: MyTextField(
            controller: upiController,
            hintText: 'Enter your UPI Id',
            obscureText: false,
          ),
        ),
        GestureDetector(
          onTap: () async => await pickImage(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: Get.height / 4,
                width: Get.width * 0.5,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image!), fit: BoxFit.cover)
                      : paymentController.paymentDetails.value?.data?.qrCode !=
                              null
                          ? DecorationImage(
                              image: NetworkImage(
                                  "${RemoteData().baseURL}${paymentController.paymentDetails.value!.data!.qrCode}"),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: image == null &&
                        paymentController.paymentDetails.value?.data?.qrCode ==
                            null
                    ? const Icon(
                        CupertinoIcons.qrcode,
                        size: 100,
                        color: greyColor,
                      )
                    : null,
              ),
              if (isUpdating)
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: primaryIconColor,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyButton(
                onTap: _onConfirmTap,
                text: 'Confirm',
              ),
              if (isUpdating) const SizedBox(height: 10),
              if (isUpdating)
                CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: textPrimaryColor),
                  ),
                  onPressed: () => paymentController.isEditing(false),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderPaymentDetails(PaymentModel payment) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _header(context),
            const SizedBox(height: 20),
            Obx(() {
              if (paymentController.isEditing.value) {
                upiController.text = payment.data?.upiId ?? '';
                return _addOrUpdatePaymentView(context, isUpdating: true);
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    payment.data?.qrCode != null
                        ? Image.network(
                            "${RemoteData().baseURL}${payment.data?.qrCode}",
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            CupertinoIcons.qrcode,
                            size: 100,
                            color: greyColor,
                          ),
                    const SizedBox(height: 20),
                    Text(
                      "UPI ID: ${payment.data?.upiId ?? ''}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textHighlightColor,
                          fontFamily: 'montserrat'),
                    ),
                    Text(
                      "Partner Name: ${payment.data?.partner?.name ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: greyColor),
                    ),
                    Text(
                      "Phone: ${payment.data?.partner?.phone ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: greyColor),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: () {
                        paymentController.isEditing(true);
                      },
                      text: 'Update Payment Details',
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final tempImage = File(pickedImage.path);
    setState(() {
      image = tempImage;
    });
  }

  void _onConfirmTap() {
    final upiId = upiController.text.trim();
    if (upiId.isEmpty || image == null) {
      showCustomCupertinoAlertDialog(
        title: 'Error',
        message: 'Please provide a valid UPI ID and QR code image.',
      );
      return;
    }

    if (!Validation.isValidUPI(upiId)) {
      showCustomCupertinoAlertDialog(
        title: 'Invalid UPI ID',
        message: 'Please enter a valid UPI ID.',
      );
      return;
    }

    paymentController.addPaymentDetails(image!, upiId);
    paymentController.isEditing(false);
  }
}
