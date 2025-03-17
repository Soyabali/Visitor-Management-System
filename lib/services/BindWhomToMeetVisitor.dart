import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindWhomToMeetVisitorRepo
{
  List bindcityWardList = [];
  Future<List> getbindWhomToMeetVisitor() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // String? sToken = prefs.getString('sToken');
    String? sToken = "840BCEF7-E02B-440D-8BDA-C1F1BF6A1C83";

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindWhomToMeet/BindWhomToMeet";
      var bindCityzenWardApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindCityzenWardApi'));

      // request.body = json.encode({
      //   "iUserId": "1000",
      // });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindcityWardList = parsedJson['Data'];
        print("Dist list Marklocation Api ----71------>:$bindcityWardList");
        return bindcityWardList;
      } else
      {
        hideLoader();
        return bindcityWardList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
