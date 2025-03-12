import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class UpdateVisitorStatusRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future updateVisitor(BuildContext context, sContactNo, selectedWardId2) async {

    try {
      print('----sContactNo-----17--$sContactNo');
      print('----selectedWardId2-----18--$selectedWardId2');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "UpdateVisitorStatus/UpdateVisitorStatus";
      var loginApi = "$baseURL$endPoint";
      print('------------17---loginApi---$loginApi');

      showLoader();
      // here token should be pass
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$loginApi'));
      request.body = json.encode(
          {
            "sContactNo": sContactNo,
            "iStatus":selectedWardId2
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
