import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindCityzenWardRepo
{
  List bindcityWardList = [];
  Future<List> getbindWard() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindPurposeVisit/BindPurposeVisit";
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
