import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/generalFunction.dart';
import '../../app/loader_helper.dart';
import '../../services/baseurl.dart';
import '../model/GetVisitorListModel.dart';


class GetvisitorList2Repo {

  var hrmsleavebalacev2List = [];
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<GetVisitorListModel>> getVisitorList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sUserId = prefs.getString('iUserId');
    // iUserId


    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetVisitorList/GetVisitorList";
    //  https://upegov.in/VistorManagementSystemApis/Api/
    var hrmsreimbursementstatusV3 = "$baseURL$endPoint";
    // var hrmsreimbursementstatusV3 = "https://upegov.in/VistorManagementSystemApis/Api/VisitorReport/VisitorReport";

    try {
      var headers = {
        'token': sToken ?? '',
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse(hrmsreimbursementstatusV3));
      request.body = json.encode({
        "sUserId":'$sUserId'
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();
        // Convert the response stream to a string
        String responseBody = await response.stream.bytesToString();
        // Decode the response body
        // List jsonResponse = jsonDecode(responseBody);
        Map<String, dynamic> parsedJson = jsonDecode(responseBody);
        List jsonResponse = parsedJson['Data'];
        print('---62----xxx--->>>>>>>---xxxx-----$jsonResponse');

        return jsonResponse
            .map((data) => GetVisitorListModel.fromJson(data)).toList();

      } else if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      } else {
        hideLoader();
        throw Exception('Failed to load reimbursement status data');
      }
    } catch (e) {
      hideLoader();
      throw Exception('An error occurred: $e');
    } finally {
      hideLoader(); // Ensure the loader is hidden in all cases
    }
  }
}
//



// class BindComplaintCategoryRepo {
//
//   GeneralFunction generalFunction = GeneralFunction();
//
//   Future<List<Map<String, dynamic>>?> bindComplaintCategory(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? sUserId = prefs.getString('iUserId');
//
//     print("------>>>>>xxx.....--iUSEDID---$sUserId");
//
//     if (sToken == null || sToken.isEmpty) {
//       print('Token is null or empty. Please check token management.');
//       return null;
//     }
//
//     var baseURL = BaseRepo().baseurl;
//     var endPoint = "GetVisitorList/GetVisitorList";
//     var bindComplaintCategoryApi = "$baseURL$endPoint";
//
//     print('Base URL: $baseURL');
//     print('Full API URL: $bindComplaintCategoryApi');
//     print('Token: $sToken');
//
//     try {
//       showLoader();
//       var headers = {
//         'token': sToken,
//         'Content-Type': 'application/json',
//       };
//       var request = http.Request('POST', Uri.parse(bindComplaintCategoryApi));
//       // Body
//       request.body = json.encode({
//         "sUserId": "$sUserId",
//       });
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//       print('Response status code: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         var data = await response.stream.bytesToString();
//         print('Response body: $data');
//
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         List<dynamic>? dataList = parsedJson['Data'];
//         print("------56--->>>  -- $dataList");
//         if (dataList != null) {
//           List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
//           return notificationList;
//         }
//         else {
//           print('Data key is null or empty.');
//           return null;
//         }
//       }else if(response.statusCode==401){
//         print("---58---->>>>.---${response.statusCode}");
//         generalFunction.logout(context);
//       }
//       else {
//         print('Failed to fetch data. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print("Exception occurred: $e");
//       throw e; // Optionally handle the exception differently
//     } finally {
//       hideLoader();
//     }
//   }
// }
