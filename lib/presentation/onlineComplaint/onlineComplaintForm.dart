import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../app/loader_helper.dart';
import '../../services/PostCitizenComplaintRepo.dart';
import '../../services/baseurl.dart';
import '../../services/bindCityzenWardRepo.dart';
import '../../services/bindSubCategoryRepo.dart';
import '../../services/markpointSubmit.dart';
import '../circle/circle.dart';
import 'onlineComplaint.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class OnlineComplaintForm extends StatefulWidget {

  var name, iCategoryCode;

  OnlineComplaintForm({super.key, required this.name, required this.iCategoryCode});

  @override
  State<OnlineComplaintForm> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OnlineComplaintForm> with WidgetsBindingObserver {

  List stateList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> bindreimouList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  bindSubCategory(String subCategoryCode) async {
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(context,subCategoryCode))!;
    print(" -----xxxxx-  subCategoryList--43---> $subCategoryList");
    setState(() {});
  }

  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard();
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _mentionController = TextEditingController();

  FocusNode _addressfocus = FocusNode();
  FocusNode _landmarkfocus = FocusNode();
  FocusNode _wardfocus = FocusNode();

  String? todayDate;
  String? consumableList;
  int count = 0;
  List? data;
  List? listCon;

  //var _dropDownSector;
  var dropDownSubCategory;
  var _dropDownWardValue;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  File? _imageFile;
  var _selectedShopId;
  var _selectedSubCategoryId;
  var _selectedWardId2;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  double? lat, long;
  bool _isLoading = false;
  var categoryType;
  var iCategoryCodeList;
  List<Map<String, dynamic>> firstFormCombinedList = [];

  // online location
  // pick image from a Camera

  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----107--$sToken');
    try {
      final pickFileid = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  void getLocation() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied. Open settings.");
      openAppSettings();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      _isLoading = false; // Stop loading
    });

    print("Latitude: $lat, Longitude: $long");
  }

  // void getLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return;
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print("Location permission denied");
  //       return;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     print("Location permissions are permanently denied. Open settings.");
  //     openAppSettings();
  //     return;
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print("Latitude---->>--156--: ${position.latitude}, Longitude: ${position.longitude}");
  //   //   double lat = double.parse('${position.latitude}');
  //   setState(() {
  //     lat = double.parse('${position.latitude}');
  //     long = double.parse('${position.longitude}');
  //   });
  //
  //   //long = '${position.longitude}' as double?;
  //   print('----lat---159-->>>--$lat');
  //   print('----long----160->>>--$long');
  // }
  // takeaLocation
  // void getLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   debugPrint("-------------Position-----------------");
  //   debugPrint(position.latitude.toString());
  //
  //   lat = position.latitude;
  //   long = position.longitude;
  //   print('-----------105--lat-xx--$lat');
  //   print('-----------106-----long----$long');
  //   // setState(() {
  //   // });
  //   debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
  //   debugPrint(position.toString());
  // }

  // generateRandomNumber
  String generateRandom20DigitNumber() {
    final Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(12).toString();
    }

    return randomNumber;
  }

  Future<void> uploadImage(String token, File imageFile) async {
    print("--------225---tolen---$token");
    print("--------226---imageFile---$imageFile");
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostCitizenImage/PostCitizenImage";
    var uploadImageApi = "$baseURL$endPoint";
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST', Uri.parse('$uploadImageApi'),
      );
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
    //  request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath('sImagePath',imageFile.path,
      ));
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      print("---------248-----$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        uplodedImage = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image--------201---->>.--: $uplodedImage');
      } else {
        print('Unexpected response format: $responseData');
      }
      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    // updatedSector();
    WidgetsBinding.instance.addObserver(this);
    getLocation();
    var subCategoryCode = "${widget.iCategoryCode}";
    categoryType = "${widget.name}";
    iCategoryCodeList = "${widget.iCategoryCode}";
    print("---------240-------$subCategoryCode");
    bindSubCategory(subCategoryCode);
    bindWard();
    generateRandom20DigitNumber();
    super.initState();
    _addressfocus = FocusNode();
    _landmarkfocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _mentionController.dispose();
    FocusScope.of(context).unfocus();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed from background, check location again
      getLocation();
    }
  }
  // bind Ward
  Widget _bindWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Ward",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWardValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWardValue = newValue;
                    wardList.forEach((element) {
                      if (element["sSectorName"] == _dropDownWardValue) {
                        _selectedWardId2 = element['iSectorCode'];

                      }
                    });
                    print("----wardCode---$_selectedWardId2");
                  });
                },
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sSectorName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sSectorName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle
                                .font14OpenSansRegularBlack45TextStyle,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.
  // function call

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: getAppBarBack(context,"Online Complaint"),
          appBar: AppBar(
            // statusBarColore
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF12375e),
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            // backgroundColor: Colors.blu
            backgroundColor: Color(0xFF255898),
            leading: GestureDetector(
              onTap: () {
                print("------back---");
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnlineComplaint()),
                );
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "${widget.name}",
                style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            //centerTitle: true,
            elevation: 0, // Removes shadow under the AppBar
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: SizedBox(
                      height: 150, // Height of the container
                      width: MediaQuery.of(context).size.width,
                      // width: 200, // Width of the container
                      //step3.jpg
                      child: Image.asset(
                        'assets/images/noidaCitizen.png',
                        // Replace 'image_name.png' with your asset image path
                        fit: BoxFit.fill, // Adjust the image fit to cover the container
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color of the container
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // Color of the shadow
                              spreadRadius: 5,
                              // Spread radius
                              blurRadius: 7,
                              // Blur radius
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // 'assets/images/favicon.png',
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 10, top: 10),
                                      child: Image.asset(
                                        'assets/images/ic_expense.png',
                                        // Replace with your image asset path
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text('Fill the below details',
                                          style: AppTextStyle
                                              .font16OpenSansRegularBlackTextStyle),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text('Category', style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "${widget.name}",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                                textAlign: TextAlign
                                                    .left, // Aligns the text to the left
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Sub Category
                                SizedBox(height: 5),
                                // WARD
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Sector',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                _bindWard(),
                                SizedBox(height: 5),
                                // Address
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Location',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // this is my TextFormFoield
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 70,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _addressfocus,
                                              controller: _addressController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  FocusScope.of(context).nextFocus(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                filled: true,
                                                // Enable background color
                                                fillColor: Color(
                                                    0xFFf2f3f5), // Set your desired background color here
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Complaint Description',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: TextFormField(
                                        focusNode: _landmarkfocus,
                                        controller: _landmarkController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            FocusScope.of(context).nextFocus(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          filled: true, // Enable background color
                                          fillColor: Color(
                                              0xFFf2f3f5), // Set your desired background color here
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                    ),
                                  ),
                                ),
                                // Mention your concerns here
                                // uplode Photo
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Uplode Photo',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                //----Card
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 80,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Column Section
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Click Photo",
                                                style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                            SizedBox(height: 5),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Please click here to take a photo",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red[300]),
                                                  ),
                                                  SizedBox(width: 0),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 4),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.red[300],
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Container Section
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                           // getLocation();
                                            pickImage();

                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Image.asset("assets/images/ic_camera.PNG",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              // child: const Icon(
                                              //   Icons.camera_alt,
                                              //   size: 30,
                                              //   color: Colors.black45,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      image != null
                                          ? Stack(
                                              children: [
                                                GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.translucent,
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             FullScreenPage(
                                                    //               child: image!,
                                                    //               dark: true,
                                                    //             )));
                                                  },
                                                  child: Container(
                                                      color:
                                                          Colors.lightGreenAccent,
                                                      height: 100,
                                                      width: 70,
                                                      child: Image.file(
                                                        image!,
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                Positioned(
                                                    bottom: 65,
                                                    left: 35,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        image = null;
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                    ))
                                              ],
                                            )
                                          : Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.red[700]),
                                            )
                                    ]),
                                SizedBox(height: 10),
                                 GestureDetector(
                                     onTap: () async {
                                       // pick a location
                                       //getLocation();
                                     getLocation();

                                     SharedPreferences prefs = await SharedPreferences.getInstance();
                                     // Contact No
                                     String? sContactNo = prefs.getString('sContactNo');
                                     // random number
                                     String random12DigitNumber = generateRandom20DigitNumber();
                                     // datrFormat
                                     DateTime now = DateTime.now();
                                     // Define the format
                                     String formattedDate = DateFormat('dd/MMM/yyyy hh:mm').format(now);
                                     // TextFormField value

                                     var location = _addressController.text.trim();
                                     var complaintDescription = _landmarkController.text.trim();

                                     var iPostedBy = "0";
                                     var iAgencyCode = "1";
                                      var sCitizenContactNo = sContactNo;
                                     // Check Form Validation
                                     final isFormValid = _formKey.currentState!.validate();

                                     print("Form Validation: $isFormValid");
                                     _isLoading ? CircularProgressIndicator() : "";

                                     if(_formKey.currentState!.validate() && _selectedWardId2 != null
                                         && location.isNotEmpty && complaintDescription.isNotEmpty && uplodedImage!=null)
                                     {

                                       // var  postComplaintResponse = await PostCitizenComplaintRepo().postComplaint(
                                       //     context,
                                       //     // random12DigitNumber,
                                       //     // categoryType,
                                       //     // _selectedWardId2,
                                       //     // location,
                                       //     // lat,
                                       //     // long,
                                       //     // complaintDescription,
                                       //     // uplodedImage,
                                       //     // formattedDate,
                                       //     // iPostedBy,
                                       //     // iAgencyCode,
                                       //     // sContactNo,
                                       //     // iCategoryCodeList,
                                       //     // image
                                       // );
                                       // print('----1092---$postComplaintResponse');
                                       // result = postComplaintResponse['Result'];
                                       // msg = postComplaintResponse['Msg'];
                                     }else{
                                         print("----Not call Api----");

                                       // to apply condtion and check if any value is not selected then give a toast
                                       if(_selectedWardId2==null){
                                         displayToast("Please Select Sector");
                                         return;
                                       }else if(location.isEmpty){
                                         displayToast("Please Enter Location");
                                         return;
                                       }else if(complaintDescription.isEmpty){
                                         displayToast("Please Enter Description");
                                         return;
                                       }else if(uplodedImage==null){
                                         displayToast("Please Pic image");
                                         return;
                                       }
                                     }
                                     if(result=="1"){
                                       displayToast(msg);
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => OnlineComplaint()),
                                       );
                                     }else{
                                       displayToast(msg);
                                     }
                                     },
                                   child: Container(
                                      width: double.infinity,
                                      // Make container fill the width of its parent
                                      height: AppSize.s45,
                                      padding: EdgeInsets.all(AppPadding.p5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF255898),
                                        // Background color using HEX value
                                        borderRadius: BorderRadius.circular(
                                            AppMargin.m10), // Rounded corners
                                      ),
                                      //  #00b3c7
                                      child: Center(
                                        child: Text(
                                          "Submit",
                                          style: AppTextStyle
                                              .font16OpenSansRegularWhiteTextStyle,
                                        ),
                                      ),
                                    ),
                                 ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // location
}
// location
