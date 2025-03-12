import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class PostCitizenComplaintRepo {
  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future postComplaint(
      BuildContext context, String visitorName, int visitorCount, String contactNo, String cameFrom,selectedWhomToMeetValue, selectedWardId2, String iVisitorId, uplodedImage,) async {
    // sharedP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('sToken');
    var iPostedBy2 = prefs.getString('sContactNo');
    var iEntryBy = prefs.getString('iUserId');

    //  ---
    // firstFormCombinedList.add({
    //   "iCompCode": random12DigitNumber,
    //   "iPointTypeCode": categoryType,
    //   "iSectorCode": _selectedWardId,
    //   "sLocation": location,
    //   "fLatitude": lat,
    //   "fLongitude": long,
    //   "sDescription": complaintDescription,
    //   "sBeforePhoto": uplodedImage,
    //   "dPostedOn": formattedDate,
    //   "iPostedBy": 0,
    //   "iAgencyCode": 1,
    //   "sCitizenContactNo": sContactNo
    // });
    //--

    try {
      showLoader();
      print('----visitorName----40---$visitorName');
      print('----visitorCount----41---$visitorCount');
      print('----contactNo---43--$contactNo');
      print('----cameFrom---44--$cameFrom');

      print('----selectedWhomToMeetValue---46--$selectedWhomToMeetValue');
      print('----selectedWardId2---47--$selectedWardId2');// lat
     ;
      print("--------55--token--$token");
      print('----51---visitorId---$iVisitorId');
      // uplodedImage
      print('----51---uplodedImage---$uplodedImage');

      var baseURL = BaseRepo().baseurl;

      /// TODO CHANGE HERE
      var endPoint = "PostVisitor/PostVisitor";
      var postComplaintApi = "$baseURL$endPoint";
      print('------------48-----postComplaintApi---$postComplaintApi');
     //  random12digitNumber  -  lat -- long -- uplodedImage ---categoryType
      String jsonResponse = '{"sArray":[{"iVisitorId":"$iVisitorId","sVisitorName":"$visitorName","sVisitorCount":"$visitorCount","sVisitorContactNo":"$contactNo","sCameFrom":"$cameFrom","iWhomToMeet":"$selectedWhomToMeetValue","iPurposeOfVisit":"$selectedWardId2","iEntryBy":"$iEntryBy","sVisitorImage":"$uplodedImage"}]}'; //  String jsonResponse = '{"sArray":[{"iVisitorId":"$visitorName","iPointTypeCode":"$iCategoryCodeList","iSectorCode":"$selectedWardId","sLocation":"$location","fLatitude":"$lat","fLongitude":"$long","sDescription":"$complaintDescription","sBeforePhoto":"$uplodedImage","dPostedOn":"$formattedDate","iPostedBy":"$iPostedBy","iAgencyCode":"$iAgencyCode","sCitizenContactNo":"$sContactNo"}]}';
// Parse the JSON response
      Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);

// Get the array value
      List<dynamic> sArray = parsedResponse['sArray'];

// Convert the array to a string representation
      String sArrayAsString = jsonEncode(sArray);

// Update the response object with the string representation of the array
      parsedResponse['sArray'] = sArrayAsString;

// Convert the updated response object back to JSON string
      String updatedJsonResponse = jsonEncode(parsedResponse);

// Print the updated JSON response (optional)
      print(updatedJsonResponse);
      print('---63-----$updatedJsonResponse');

//Your API call
      var headers = {'token': '$token', 'Content-Type': 'application/json'};

      var request = http.Request('POST',Uri.parse('$postComplaintApi'));
      request.body =
          updatedJsonResponse; // Assign the JSON string to the request body
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('-------89--$map');
      print('---90---${response.statusCode}');
      // var response;
      // var map;
      //print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('----------96-----$map');
        return map;
      } else if(response.statusCode==401)
      {
        generalFunction.logout(context);
      }else{
        print('----------99----$map');
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