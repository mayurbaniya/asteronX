import 'package:asteron_x/service/getx/controller/user_controller.dart';
import 'package:asteron_x/service/getx/service/leads_service.dart';
import 'package:asteron_x/service/models/leads_model.dart';
import 'package:asteron_x/widgets/x_dialog.dart';
import 'package:get/get.dart';

class LeadsController extends GetxController {
  var isLoading = false.obs;
  var leads = Rxn<MyLeadsModel>();
  UserController userController = Get.put(UserController());

  // Pagination parameters
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var sortBy = 'time'.obs;
  var sortDir = 'desc'.obs;

  // Fetch leads with pagination and sorting
  void fetchAllLeads() async {
    try {
      isLoading(true);

      // If leads are already loaded, no need to re-fetch (unless forced)
      if (leads.value != null &&
          leads.value!.content != null &&
          leads.value!.content!.isNotEmpty) {
        return;
      } else {
        int prtID = userController.user.value!.id ?? 0;
        MyLeadsModel? fetchedLead = await LeadsService.fetchAllLeads(
          prtID,
          currentPage.value,
          pageSize.value,
          sortBy.value,
          sortDir.value,
        );
        if (fetchedLead != null) {
          leads.value = fetchedLead;
        }
      }
    } catch (e) {
      // Handle error
      print("Error fetching leads: $e");
    } finally {
      isLoading(false);
    }
  }

  // Forced refresh to fetch leads (without checking if they exist)
  void fetchAllLeadsForced() async {
    try {
      isLoading(true);
      int prtID = userController.user.value!.id ?? 0;
      MyLeadsModel? fetchedLead = await LeadsService.fetchAllLeads(
        prtID,
        currentPage.value,
        pageSize.value,
        sortBy.value,
        sortDir.value,
      );
      if (fetchedLead != null) {
        leads.value = fetchedLead;
      }
    } catch (e) {
      showCustomCupertinoAlertDialog(title: 'Error', message: '$e');
    } finally {
      isLoading(false);
    }
  }

  // Method to load next page
  void loadNextPage() {
    currentPage.value++;
    fetchAllLeadsForced();
  }

  // Method to load previous page
  void loadPreviousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      fetchAllLeadsForced();
    }
  }

  // Method to update sort order and reset pagination
  void updateSortOrder(String newSortBy, String newSortDir) {
    sortBy.value = newSortBy;
    sortDir.value = newSortDir;
    currentPage.value = 0; // Reset to the first page when changing sorting
    fetchAllLeadsForced();
  }

  // Add a new lead and update leads list
  void addNewLead(String name, String vehicle, String phone, String city,
      String finance, String notes, Function onLeadSubmitted) async {
    isLoading(true);
    try {
      int prtID = userController.user.value!.id ?? 0;

      LeadsService.saveLead(prtID, name, vehicle, phone, city, finance, notes);

      fetchAllLeadsForced();

      // Call the callback to update the tab to MyLeads
      onLeadSubmitted(); // Switch to the MyLeads tab (index 0)
    } catch (e) {
      showCustomCupertinoAlertDialog(title: 'Error', message: '$e');
    } finally {
      isLoading(false);
    }
  }
}
