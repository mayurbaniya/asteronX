// user related
import 'package:asteron_x/service/firebase/remote_data.dart';

final String url_signIn = '${RemoteData().baseURL}/partner/activity/login';
final String url_allLeads =
    '${RemoteData().baseURL}/partner/activity/get-all-leads';
final String url_leaderBoard =
    '${RemoteData().baseURL}/partner/activity/leaderboard';
final String url_addNewLead =
    '${RemoteData().baseURL}/partner/activity/add-lead';
final String url_addPaymentInfo =
    '${RemoteData().baseURL}/partner/activity/payment-details';
final String url_updatePaymentInfo =
    '${RemoteData().baseURL}/partner/activity/update-payment-details';
final String url_getPaymentInfo =
    '${RemoteData().baseURL}/partner/activity/payment-details';

// other constants:
final String paymentDetailsKey = "paymentDetails";
