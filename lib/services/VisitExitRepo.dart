
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class VisitExitRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future visitExit(BuildContext context,visitorID,) async {
    // sharedPreference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    var iUserId = prefs.getString('iUserId');// iUserId
     print("-----iUserId---------xxxx>>>>>-----21----$iUserId");
    print("-----visitorID------>>>>>>----22----$visitorID");
    print("-----token----$sToken");

    try {

      // print('----iVisitorId------18-visitorID');
      // print('----sToken------18-$sToken');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "ExitEntry/ExitEntry";
      var registrationApi = "$baseURL$endPoint";
      print('------------17---registrationApi---$registrationApi');

      showLoader();
     // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$registrationApi'));
      request.body = json.encode(
          {
            // "iVisitorId": iVisitorId,
            // "sOutBy":sOutBy,
            "iVisitorId": visitorID,
            "sOutBy":iUserId,

          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---LOGINaPI RESPONSE----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }

}

// class VisitExitRepo {
//
//   GeneralFunction generalFunction = GeneralFunction();
//
//   Future<List<Map<String, dynamic>>?> visitExit(BuildContext context) async {
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
//     var endPoint = "ExitEntry/ExitEntry";
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
//         "iVisitorId": "",
//         "sOutBy": "",
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
