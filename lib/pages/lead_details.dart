import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/utils/images.dart';
import 'package:asteron_x/widgets/custom_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetails extends StatefulWidget {
  const LeadDetails({super.key});

  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  Content lead = Get.arguments;

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();
    noteController.text = lead.noteForPrt ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: secondaryColor,
            )),
        backgroundColor: lead.status == 'NEW'
            ? Colors.deepPurple
            : lead.status == 'CLOSED'
                ? Colors.green
                : lead.status == 'ONGOING'
                    ? Colors.blue
                    : lead.status == 'DELETED'
                        ? Colors.redAccent
                        : Colors.grey,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: AssetImage(profileIMG)),
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'lead details',
                    style: TextStyle(
                        color: textHighlightColor, fontFamily: 'montserrat'),
                  ),
                ),
              ],
            ),
            _FormRow(
              tileIcon: Icon(Icons.person),
              tileTitle: 'Customer Name',
              tileValue: lead.clientName ?? '',
            ),
            _FormRow(
              tileIcon: Icon(Icons.pedal_bike),
              tileTitle: 'Vehicle',
              tileValue: lead.vehicle ?? '',
            ),
            _FormRow(
              tileIcon: Icon(Icons.location_pin),
              tileTitle: 'city',
              tileValue: lead.city ?? '',
            ),
            _FormRow(
              tileIcon: Icon(CupertinoIcons.money_dollar),
              tileTitle: 'Finance',
              tileValue: lead.isFinanceInterested ?? '',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: Get.height * 0.2,
                    width: Get.width * 0.45,
                    decoration: BoxDecoration(color: secondaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'expected Earning',
                          style: TextStyle(
                              fontSize: 12,
                              color: greyColor,
                              fontFamily: 'montserrat'),
                        ),
                        Text(
                          lead.expectedEarnings ?? '-',
                          style: TextStyle(
                              fontSize: 28,
                              color: CupertinoColors.systemGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat'),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: Get.height * 0.2,
                    width: Get.width * 0.45,
                    decoration: BoxDecoration(color: secondaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Actual Earned',
                          style: TextStyle(
                              fontSize: 12,
                              color: greyColor,
                              fontFamily: 'montserrat'),
                        ),
                        Text(
                          lead.partnersTake ?? '-',
                          style: TextStyle(
                              fontSize: 28,
                              color: CupertinoColors.systemGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: Get.height * 0.05,
              width: Get.width * 0.95,
              decoration: BoxDecoration(color: secondaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Lead Status', // Default title
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'montserrat',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(
                      lead.status == 'NEW'
                          ? Icons.fiber_new_rounded
                          : lead.status == 'CLOSED'
                              ? Icons.check_circle_rounded
                              : lead.status == 'ONGOING'
                                  ? Icons.update_rounded
                                  : lead.status == 'DELETED'
                                      ? Icons.delete_forever_rounded
                                      : Icons.info,
                      size: 30,
                      color: lead.status == 'NEW'
                          ? Colors.deepPurple
                          : lead.status == 'CLOSED'
                              ? Colors.green
                              : lead.status == 'ONGOING'
                                  ? Colors.blue
                                  : lead.status == 'DELETED'
                                      ? Colors.redAccent
                                      : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(color: textHighlightColor),
                minLines: 1, // Minimum number of lines
                maxLines:
                    null, // Allow dynamic number of lines based on content
                enableSuggestions: false,
                controller: noteController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'notes from asteron*',
                  filled: true,
                  counterText: '', // Hides the counter text
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        10.0, // Adjust vertical padding to give space for text
                    horizontal: 10.0,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 0.5, color: greyColor),
                  ),
                  hintStyle: TextStyle(
                    color: greyColor, // Change the hint text color
                  ),
                ),
              ),
            ),
            CustomExpansionTile(title: 'Payment & transaction', data: [
              {
                'icon': CupertinoIcons.money_rubl_circle_fill,
                'label': 'Payment status',
                'value': lead.paymentStatus ?? '-'
              },
              {
                'icon': Icons.payment_outlined,
                'label': 'Transaction ID',
                'value': lead.txnId ?? '---'
              },
              {
                'icon': Icons.check_circle_rounded,
                'label': 'Lead closed on',
                'value': lead.leadClosedOn ?? '-'
              },
            ]),
          ],
        ),
      )),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    this.tileTitle = '', // Optional: defaults to empty string
    this.tileValue = '', // Optional: defaults to empty string
    this.tileIcon =
        const Icon(Icons.info), // Optional: defaults to an info icon
    this.iconColor = Colors.black, // Optional: defaults to black
    this.titleColor = Colors.grey, // Optional: defaults to grey
    this.valueColor = Colors.black, // Optional: defaults to black
  });

  final String tileTitle;
  final String tileValue;
  final Icon tileIcon;
  final Color iconColor;
  final Color titleColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      height: Get.height * 0.05,
      width: Get.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: tileIcon ??
                    const Icon(Icons.info), // Use the custom icon or fallback
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  tileTitle.isNotEmpty ? tileTitle : '', // Default title
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: 'montserrat',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              tileValue.isNotEmpty ? tileValue : '', // Default value
              style: TextStyle(
                color: valueColor,
                fontFamily: 'montserrat',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
