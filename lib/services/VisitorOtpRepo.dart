import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class VisitorOtpRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future visitorOtp(BuildContext context, String otp) async {
    // to find local data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sContactNo = prefs.getString('sContactNo');
    print("------19----->>>>---contactNo--$sContactNo");
    print("------21----->>>>---OTP--$otp");

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "VerifiyOTP/VerifiyOTP";
      var visitorOTPApi = "$baseURL$endPoint";
      print('------------17---visitorOTPApi---$visitorOTPApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$visitorOTPApi'));
      request.body = json.encode(
          {
            "sContactNo":sContactNo,
            "sOtp":otp
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---visitorOTPApi RESPONSE----$map');

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
