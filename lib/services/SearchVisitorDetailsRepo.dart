
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class SearchVisitorDetailsRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future searchVisitorDetail(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sContactNo = prefs.getString('sContactNo2');

    try {
      print('----sContactNo-----17--$sContactNo');


      var baseURL = BaseRepo().baseurl;
      var endPoint = "SearchVisitorDetails/SearchVisitorDetails";
      var searchVisigtorDetail = "$baseURL$endPoint";
      print('------------17---searchVisigtorDetail---$searchVisigtorDetail');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$searchVisigtorDetail'));
      request.body = json.encode(
          {
            "sContactNo":sContactNo
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
      }else if(response.statusCode==401){
        generalFunction.logout(context);
      }
      else {
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


// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import '../app/loader_helper.dart';
// import 'baseurl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
//
// class SearchVisitorDetailsRepo
// {
//   List bindcityWardList = [];
//   Future<List> searchVisitorDetail() async
//   {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sContactNo = prefs.getString('sContactNo');
//
//     print('---19-  sContactNo---$sContactNo');
//
//     try
//     {
//       showLoader();
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "SearchVisitorDetails/SearchVisitorDetails";
//       var searchVisitorDetailsApi = "$baseURL$endPoint";
//
//       // var headers = {
//       //   'token': '$sToken'
//       // };
//       var request = http.Request('POST', Uri.parse('$searchVisitorDetailsApi'));
//
//       request.body = json.encode({
//         "sContactNo": sContactNo,
//       });
//
//       //request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         bindcityWardList = parsedJson['Data'];
//         print("Dist list Marklocation Api ----71------>:$bindcityWardList");
//         return bindcityWardList;
//       } else
//       {
//         hideLoader();
//         return bindcityWardList;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
