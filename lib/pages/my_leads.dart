import 'package:asteron_x/service/getx/controller/leads_controller.dart';
import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/utils/colors.dart';
import 'package:asteron_x/utils/images.dart';
import 'package:asteron_x/widgets/x_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLeads extends StatefulWidget {
  const MyLeads({super.key});

  @override
  State<MyLeads> createState() => _MyLeadsState();
}

class _MyLeadsState extends State<MyLeads> {
  final LeadsController leadsController = Get.put(LeadsController());

  @override
  void initState() {
    super.initState();
    leadsController.fetchAllLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Add the guide widget
          _buildGuide(),

          // Sorting and pagination controls
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You shared total ${leadsController.leads.value?.totalElements ?? 0} ${leadsController.leads.value?.totalElements == 1 ? 'Lead' : 'Leads'}',
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showSortOptions(context);
                  },
                  icon: Icon(
                    Icons.filter_alt_rounded,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Obx(() {
              if (leadsController.isLoading.value) {
                return CustomLoadingIndicator(color: loadingColor);
              }

              if (leadsController.leads.value == null ||
                  leadsController.leads.value!.content == null ||
                  leadsController.leads.value!.content!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 80, color: secondaryColor),
                    SizedBox(height: 20),
                    Text(
                      'No Leads Available',
                      style: TextStyle(fontSize: 18, color: textPrimaryColor),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _myLeadsTile(leadsController.leads.value!), // Display leads

                    // Pagination footer
                    PaginationFooter(
                      currentPage: leadsController.leads.value?.pageNumber ?? 1,
                      totalPages: leadsController.leads.value?.totalPages ?? 1,
                      onPreviousPage: leadsController.loadPreviousPage,
                      onNextPage: leadsController.loadNextPage,
                      isLastPage:
                          leadsController.leads.value?.lastPage ?? false,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Sort By'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                leadsController.updateSortOrder('time', 'desc');
                Navigator.pop(context); // Close the modal
              },
              child: Text('Newer first'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                leadsController.updateSortOrder('time', 'asc');
                Navigator.pop(context); // Close the modal
              },
              child: Text('Older first'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            isDestructiveAction: true,
          ),
        );
      },
    );
  }

  Widget _buildGuide() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Icons.fiber_new_rounded, Colors.deepPurple, "NEW"),
          _buildLegendItem(Icons.update_rounded, Colors.blue, "ONGOING"),
          _buildLegendItem(Icons.check_circle_rounded, Colors.green, "CLOSED"),
          _buildLegendItem(Icons.delete_forever_rounded, Colors.red, "DELETED"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: textPrimaryColor),
        ),
      ],
    );
  }

  Widget _myLeadsTile(MyLeadsModel myLeads) {
    return GridView.builder(
      shrinkWrap: true, // Prevent unbounded height error
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3, // Adjust as needed
      ),
      itemCount: myLeads.content!.length,
      itemBuilder: (context, index) {
        Content lead = myLeads.content![index];
        String title = lead.clientName ?? '-';
        String vehicle = lead.vehicle ?? '-';

        IconData tagIcon;
        Color tagColor;

        switch (lead.status) {
          case 'NEW':
            tagIcon = Icons.fiber_new_rounded;
            tagColor = Colors.deepPurple;
            break;
          case 'ONGOING':
            tagIcon = Icons.update_rounded;
            tagColor = Colors.blue;
            break;
          case 'CLOSED':
            tagIcon = Icons.check_circle_rounded;
            tagColor = Colors.green;
            break;
          case 'DELETED':
            tagIcon = Icons.delete_forever_rounded;
            tagColor = Colors.red;
            break;
          default:
            tagIcon = Icons.help_outline_rounded;
            tagColor = Colors.black;
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              // Main container
              GestureDetector(
                onTap: () {
                  Get.toNamed('/details', arguments: lead);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Image Container (30% width)
                      Container(
                        width: Get.width * 0.3, // 30% of screen width
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(profileIMG),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimaryColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Vehicle: $vehicle',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  color: greyColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Provider: ${lead.leadProvider?.name ?? '-'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tag Icon
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: tagColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    tagIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final bool isLastPage;

  const PaginationFooter({
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Page Icon Button
          IconButton(
            onPressed: currentPage == 0 ? null : onPreviousPage,
            icon: Icon(Icons.arrow_back_ios,
                color: currentPage == 0 ? Colors.grey : Colors.black),
          ),

          // Page Display
          Text('Page $currentPage / $totalPages'),

          // Next Page Icon Button (disabled if last page)
          IconButton(
            onPressed: isLastPage ? null : onNextPage,
            icon: Icon(Icons.arrow_forward_ios,
                color: isLastPage ? Colors.grey : Colors.black),
          ),
        ],
      ),
    );
  }
}
