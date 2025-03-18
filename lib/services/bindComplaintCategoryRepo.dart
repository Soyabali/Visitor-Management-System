
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class BindComplaintCategoryRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> bindComplaintCategory(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? sUserId = prefs.getString('iUserId');

    print("------>>>>>xxx.....--iUSEDID---$sUserId");

    if (sToken == null || sToken.isEmpty) {
      print('Token is null or empty. Please check token management.');
      return null;
    }

    var baseURL = BaseRepo().baseurl;
    var endPoint = "GetVisitorList/GetVisitorList";
    var bindComplaintCategoryApi = "$baseURL$endPoint";

    print('Base URL: $baseURL');
    print('Full API URL: $bindComplaintCategoryApi');
    print('Token: $sToken');

    try {
      showLoader();
      var headers = {
        'token': sToken,
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse(bindComplaintCategoryApi));
      // Body
      request.body = json.encode({
        "sUserId": "$sUserId",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        print('Response body: $data');

        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['Data'];
     print("------56--->>>  -- $dataList");
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

// class BindComplaintCategoryRepo {
//   GeneralFunction generalFunction = GeneralFunction();
//
//   Future<List<Map<String, dynamic>>?> bindComplaintCategory(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? sUserId = prefs.getString('iUserId');
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
//
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


// class BindComplaintCategoryRepo {
//
//   GeneralFunction generalFunction = GeneralFunction();
//   Future<List<Map<String, dynamic>>?> bindComplaintCategory(BuildContext context) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//
//     print('---token----$sToken');
//
//     try {
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "BindCitizenPointType/BindCitizenPointType";
//       var bindComplaintCategoryApi = "$baseURL$endPoint";
//       showLoader();
//
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('GET', Uri.parse('$bindComplaintCategoryApi'));
//
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       // if(response.statusCode ==401){
//       //   generalFunction.logout(context);
//       // }
//       if (response.statusCode == 200) {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         List<dynamic>? dataList = parsedJson['Data'];
//
//         if (dataList != null) {
//           List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
//           print("xxxxx------46----: $notificationList");
//           return notificationList;
//         } else{
//           return null;
//         }
//       } else {
//         hideLoader();
//         return null;
//       }
//     } catch (e) {
//       hideLoader();
//       debugPrint("Exception: $e");
//       throw e;
//     }
//   }
// }
