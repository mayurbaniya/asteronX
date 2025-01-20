import 'package:asteron_x/service/getx/controller/leads_controller.dart';
import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/helper/validator.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/widgets/x_button.dart';
import 'package:asteron_x/widgets/x_container.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:asteron_x/widgets/x_inputfield.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddLeads extends StatefulWidget {
  final Function onLeadSubmitted; // Callback function to change the tab

  const AddLeads({super.key, required this.onLeadSubmitted});

  @override
  State<AddLeads> createState() => _AddLeadsState();
}

class _AddLeadsState extends State<AddLeads> {
  int _currentStep = 0;

  UserController userController = Get.put(UserController());
  LeadsController leadsController = Get.put(LeadsController());

  // Controllers for step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Controllers for step 2
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _financeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userController.getUserDataFromSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the step indicator
                    children: List.generate(3, (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Ensure each step is centered
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: _currentStep >= index
                                ? primaryColor
                                : greyColor,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: secondaryColor),
                            ),
                          ),
                          if (index < 2)
                            Container(
                              height: 2, // Thickness of the connector
                              width: 30, // Set a fixed width for the connector
                              color: _currentStep > index
                                  ? primaryColor
                                  : greyColor,
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_currentStep == 0) ...[
                        SizedBox(height: Get.height * 0.10),
                        MyTextField(
                          prefixIcon: Icon(Icons.person),
                          controller: _nameController,
                          hintText: 'Customer Name',
                          obscureText: false,
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          prefixIcon: Icon(Icons.pedal_bike),
                          controller: _vehicleController,
                          hintText: 'Vehicle of interest',
                          obscureText: false,
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          prefixIcon: Icon(Icons.phone),
                          controller: _phoneController,
                          hintText: 'Customer Number',
                          obscureText: false,
                        ),
                      ],
                      if (_currentStep == 1) ...[
                        SizedBox(height: Get.height * 0.10),
                        MyTextField(
                          prefixIcon: Icon(Icons.add_location_alt),
                          controller: _cityController,
                          hintText: 'Customer City',
                          obscureText: false,
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          prefixIcon: Icon(FontAwesomeIcons.wallet),
                          controller: _financeController,
                          hintText: 'Interested in Finance?',
                          obscureText: false,
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          prefixIcon: Icon(Icons.notes),
                          controller: _notesController,
                          hintText: 'Additional Notes (Optional)',
                          obscureText: false,
                        ),
                      ],
                      if (_currentStep == 2) ...[
                        buildFormDetails(
                            _nameController.text,
                            _vehicleController.text,
                            _phoneController.text,
                            _cityController.text,
                            _financeController.text,
                            _notesController.text),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _currentStep == 0
                    ? MyButton(
                        onTap: () {
                          setState(() {
                            _currentStep += 1;
                          });
                        },
                        text: 'Continue',
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep -= 1;
                                });
                              },
                              child: Text(
                                'Back',
                                style: TextStyle(color: greyColor),
                              ),
                            ),
                          if (_currentStep < 2)
                            MyButton(
                              onTap: () {
                                setState(() {
                                  _currentStep += 1;
                                });
                              },
                              text: 'Continue',
                            ),
                          if (_currentStep == 2)
                            Obx(() {
                              if (leadsController.isLoading.value == true) {
                                return Text('loading...');
                              }
                              return MyButton(
                                onTap: () {
                                  _handleSubmit(
                                    _nameController.text,
                                    _vehicleController.text,
                                    _phoneController.text,
                                    _cityController.text,
                                    _financeController.text,
                                    _notesController.text,
                                  );
                                },
                                text: 'share lead',
                              );
                            }),
                        ],
                      ),
              ),
            ],
          ),
          Obx(() {
            if (leadsController.isLoading.value == true) {
              return GestureDetector(
                onTap: () {}, // Disable interaction with background
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CustomLoadingIndicator(color: loadingColor),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget buildFormDetails(String name, String vehicleName, String phone,
      String city, String finance, String notes) {
    return ReusableContainer(
      radius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                'Filled Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'montserrat',
                  fontSize: 18,
                  color: textHighlightColor,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Center(
              child: Text(
                'If you fill dummy/fake data, your account may get banned*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'montserrat',
                  fontSize: 8,
                  color: greyColor,
                ),
              ),
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            border: TableBorder.all(color: Colors.grey.shade300, width: 1),
            children: [
              _buildTableRow('Customer Name', name),
              _buildTableRow('vehicle', vehicleName),
              _buildTableRow('Phone', phone),
              _buildTableRow('City', city),
              _buildTableRow('Finance', finance),
              _buildTableRow('Notes', notes),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'montserrat',
              fontSize: 12,
              color: textPrimaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'montserrat',
              fontSize: 14,
              color: greyColor,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(String name, String vehicleName, String phone, String city,
      String finance, String notes) {
    // Debugging Logs
    print('HandleSubmit called');
    print(
        'Name: $name, Vehicle: $vehicleName, Phone: $phone, City: $city, Finance: $finance, Notes: $notes');

    if (Validation.isEmpty(name) ||
        Validation.isEmpty(vehicleName) ||
        Validation.isEmpty(phone) ||
        Validation.isEmpty(finance) ||
        Validation.isEmpty(city)) {
      showCustomCupertinoAlertDialog(
        title: 'error',
        message: 'Required fields cannot be empty',
      );
      return;
    }

    if (!Validation.isValidName(name)) {
      showCustomCupertinoAlertDialog(
        title: 'error',
        message: 'invalid name format',
      );
      return;
    }

    if (!Validation.isValidPhone(phone)) {
      showCustomCupertinoAlertDialog(
        title: 'error',
        message: 'invalid phone number',
      );
      return;
    }

    if (!Validation.isVehicleNameValid(vehicleName)) {
      showCustomCupertinoAlertDialog(
        title: 'error',
        message: 'invalid vehicle name',
      );
      return;
    }

    if (notes.isNotEmpty && !Validation.isNotesValid(notes)) {
      showCustomCupertinoAlertDialog(
        title: 'error',
        message:
            'invalid notes size, minimum 3 and max 100 characters are allowed',
      );
      return;
    }

    // Proceed with the submit action if validation is successful
    leadsController.addNewLead(
        name, vehicleName, phone, city, finance, notes, widget.onLeadSubmitted);
  }
}
