
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class PostImageRepo {
  Future postImage(BuildContext context, File? imageFile) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');
    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "PostImage/PostImage";
      var postImageApi = "$baseURL$endPoint";
      print('------------17---sectorApi---$postImageApi');
      showLoader();
      var headers = {
        'token': '$sToken'
      };
      var request = http.MultipartRequest('POST', Uri.parse('$postImageApi'));
      request.files.add(await http.MultipartFile.fromPath('', '/C:/Users/SynergyTelematics/Desktop/WhatsApp Image 2024-04-23 at 3.59.09 PM.jpeg'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        hideLoader();
        print('----------53-----$map');
        return map;
      } else {
        print('----------56  Response----$map');
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
