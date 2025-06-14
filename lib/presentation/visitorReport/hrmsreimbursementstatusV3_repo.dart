import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/generalFunction.dart';
import '../../app/loader_helper.dart';
import '../../services/baseurl.dart';
import 'hrmsreimbursementstatusV3Model.dart';

class Hrmsreimbursementstatusv3Repo {

  var hrmsleavebalacev2List = [];
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Hrmsreimbursementstatusv3model>> hrmsReimbursementStatusList(
      BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    // iUserId
    String? iUserId = prefs.getString('iUserId');

    print('--15 --firstOfMonthDay----26--xxxx--$firstOfMonthDay');
    print('--16 --lastDayOfCurrentMonth---27--xxxx--$lastDayOfCurrentMonth');
    print('--17 --iUserId----28---xxx---$iUserId');

    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "VisitorReport/VisitorReport";
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
        // "dFrormDate": "2025-03-02",
        // "dToDate": "2025-03-15",
        // "sUserId":"1"
        "dFrormDate": firstOfMonthDay,
        "dToDate": lastDayOfCurrentMonth,
        "sUserId":iUserId
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
            .map((data) => Hrmsreimbursementstatusv3model.fromJson(data))
            .toList();

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

// Future<List<Hrmsreimbursementstatusv3model>>  hrmsReimbursementStatusList(BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth) async{
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? sToken = prefs.getString('sToken');
  //     String? contactNo = prefs.getString('sContactNo');
  //     print('--15 --firstOfMonthDay--$firstOfMonthDay');
  //     print('--16 --lastDayOfCurrentMonth--$lastDayOfCurrentMonth');
  //     print('--17 --contactNo--$contactNo');
  //     showLoader();
  //         var baseURL = BaseRepo().baseurl;
  //         var endPoint = "hrmsreimbursementstatusV3/hrmsreimbursementstatusV3";
  //          var hrmsreimbursementstatusV3 = "$baseURL$endPoint";
  //
  //   try {
  //     var headers = {
  //       'token': '$sToken',
  //       'Content-Type': 'application/json'
  //     };
  //     var request = http.Request('POST', Uri.parse('$hrmsreimbursementstatusV3'));
  //     request.body = json.encode({
  //             "sType": "A",
  //             "dFromDate": firstOfMonthDay,
  //             "sUserId": contactNo,
  //             "iPage": "1",
  //             "iPageSize": "10",
  //             "dToDate": lastDayOfCurrentMonth,
  //     });
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 200) {
  //       hideLoader();
  //       // Convert the response stream to a string
  //       String responseBody = await response.stream.bytesToString();
  //       // Decode the response body
  //       List jsonResponse = jsonDecode(responseBody);
  //       print('---54--$jsonResponse');
  //       // Return the list of LeaveData
  //       return jsonResponse.map((data) => Hrmsreimbursementstatusv3model.fromJson(data)).toList();
  //
  //     }
  //     else if(response.statusCode==401){
  //       generalFunction.logout(context);
  //     }
  //     else {
  //       hideLoader();
  //       throw Exception('Failed to load leave data');
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     throw (e);
  //   }
  // }
}
