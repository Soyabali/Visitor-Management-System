
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class VisitorReportrepo {
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> visitorReport(BuildContext context, String? firstOfMonthDay, String? lastDayOfCurrentMonth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sUserId = prefs.getString('iUserId');

    print("---->>>>------19---FirstDay---$firstOfMonthDay");
    print("---->>>>------19----last date--$lastDayOfCurrentMonth");
    print("---->>>>------19----userid--$sUserId");


    if (sToken == null || sToken.isEmpty) {
      print('Token is null or empty. Please check token management.');
      return null;
    }

    var baseURL = BaseRepo().baseurl;
    var endPoint = "VisitorReport/VisitorReport";
    var bindComplaintCategoryApi = "$baseURL$endPoint";

    print('Base URL: $baseURL');
    print('Full API URL: $bindComplaintCategoryApi');
    print('Token------>>>>>---token---->>>>: $sToken');

    try {
      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://upegov.in/VistorManagementSystemApis/Api/VisitorReport/VisitorReport'));
      request.body = json.encode({
        "dFrormDate": firstOfMonthDay,
        "dToDate": lastDayOfCurrentMonth,
        "sUserId": sUserId
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // var headers = {
      //   'token': sToken,
      //   'Content-Type': 'application/json',
      // };
      // var request = http.Request('POST', Uri.parse(bindComplaintCategoryApi));
      // // Body
      // request.body = json.encode({
      //   "dFrormDate": "25-03-02",
      //   "dToDate": "2025-03-15",
      //   "sUserId": "1",
      //
      // });
      // request.headers.addAll(headers);
      //
      // http.StreamedResponse response = await request.send();
      // print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        print('Response body: $data');

        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['Data'];

        if (dataList != null) {
          List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
          return notificationList;
        }
        else {
          print('Data key is null or empty.');
          return null;
        }
      }else if(response.statusCode==401){
        print("---58---->>>>.---${response.statusCode}");
        generalFunction.logout(context);
      }
      else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw e; // Optionally handle the exception differently
    } finally {
      hideLoader();
    }
  }
}