import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../app/loader_helper.dart';
import '../../services/VisitorReportRepo.dart';
import '../../services/postimagerepo.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import 'hrmsreimbursementstatusV3Model.dart';
import 'hrmsreimbursementstatusV3_repo.dart';

class Reimbursementstatus extends StatelessWidget {
  const Reimbursementstatus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      //debugShowCheckedModeBanner: false,
      home: ReimbursementstatusPage(),
    );
  }
}

class ReimbursementstatusPage extends StatefulWidget {
  const ReimbursementstatusPage({super.key});

  @override
  State<ReimbursementstatusPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReimbursementstatusPage> {
  List<Map<String, dynamic>>? reimbursementStatusList;

  // List<Map<String, dynamic>> _filteredData = [];
  ///List<dynamic>  hrmsReimbursementLis
  ///
  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();
  DateTime? _date;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus(); // Unfocus when app is paused
    }
  }

  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  late Future<List<Hrmsreimbursementstatusv3model>> reimbursementStatusV3;
  List<Hrmsreimbursementstatusv3model> _allData = []; // Holds original data
  List<Hrmsreimbursementstatusv3model> _filteredData =
      []; // Holds filtered data
  TextEditingController _takeActionController = TextEditingController();

  //

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;

  // GeneralFunction generalFunction = GeneralFunction();
  //    firstOfMonthDay!, lastDayOfCurrentMonth!
  getEmergencyTitleResponse(
    String firstOfMonthDay,
    String? lastDayOfCurrentMonth,
  ) async {
    emergencyTitleList = await VisitorReportrepo().visitorReport(
      context,
      firstOfMonthDay,
      lastDayOfCurrentMonth,
    );
    print('------95------sss---->>>>>>>>>--xxxxx--$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }

  // Distic List

  // hrmsReimbursementStatus(
  //   String firstOfMonthDay,
  //   String lastDayOfCurrentMonth,
  // ) async {
  //   reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo()
  //       .hrmsReimbursementStatusList(
  //         context,
  //         firstOfMonthDay,
  //         lastDayOfCurrentMonth,
  //       );
  //
  //   reimbursementStatusV3.then((data) {
  //     setState(() {
  //       _allData = data; // Store the data
  //       _filteredData = _allData; // Initially, no filter applied
  //     });
  //   });
  //   // reimbursementStatusV3 = (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay,lastDayOfCurrentMonth)) as Future<List<Hrmsreimbursementstatusv3model>>;
  //   // _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
  //   print(
  //     " -----xxxxx-  reimbursementStatusList--116--->>>> --xxx-----> $reimbursementStatusList",
  //   );
  //   // setState(() {});
  // }
  //
  // // filter data
  // void filterData(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredData = _allData; // Show all data if search query is empty
  //     } else {
  //       _filteredData =
  //           _allData.where((item) {
  //             return item.iVisitorId.toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ) || // Filter by project name
  //                 item.sVisitorName.toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ) ||
  //                 item.sPurposeVisitName.toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 );
  //             // Filter by employee name
  //           }).toList();
  //     }
  //   });
  // }

  // postImage
  postimage() async {
    print('----ImageFile----$_imageFile');
    var postimageResponse = await PostImageRepo().postImage(
      context,
      _imageFile,
    );
    print(" -----xxxxx-  --72---> $postimageResponse");
    setState(() {});
  }

  String? _chosenValue;
  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  // focus
  // FocusNode locationfocus = FocusNode();
  FocusNode _shopfocus = FocusNode();
  FocusNode _owenerfocus = FocusNode();
  FocusNode _contactfocus = FocusNode();
  FocusNode _landMarkfocus = FocusNode();
  FocusNode _addressfocus = FocusNode();

  // FocusNode descriptionfocus = FocusNode();
  String? todayDate;

  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;
  var fromPicker;
  var toPicker;
  var sTranCode;
   Color? colore;

  // Uplode Id Proof with gallary
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 65,
      );
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------135----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // multifilepath
  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // image code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'),
      );

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body);

      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      print('----174---$uplodedImage');
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }

  multipartProdecudre() async {
    print('----139--$image');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token---$sToken');

    var headers = {'token': '$sToken', 'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'),
    );
    request.body = json.encode({"sImagePath": "$image"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print('---155----$responseData');
  }

  // getCurrentDate().
  getCurrentdate() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    firstOfMonthDay = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    // last day of the current month
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    lastDayOfCurrentMonth = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);
    setState(() {});
    if (firstDayOfNextMonth != null && lastDayOfCurrentMonth != null) {
      print('You should call api');
      reimbursementStatusV3 =
          (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(
                context,
                firstOfMonthDay!,
                lastDayOfCurrentMonth!,
              ))
              as Future<List<Hrmsreimbursementstatusv3model>>;
      print('---272---->>>>>  xxxxxxx--$reimbursementStatusV3');
    } else {
      print('You should  not call api');
    }
  }

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    getCurrentdate();
    getEmergencyTitleResponse(firstOfMonthDay!, lastDayOfCurrentMonth);
    //hrmsReimbursementStatus(firstOfMonthDay!, lastDayOfCurrentMonth!);
    super.initState();
    _shopfocus = FocusNode();
    _owenerfocus = FocusNode();
    _contactfocus = FocusNode();
    _landMarkfocus = FocusNode();
    _addressfocus = FocusNode();
  }

  // location
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

  // didUpdateWidget

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shopfocus.dispose();
    _owenerfocus.dispose();
    _contactfocus.dispose();
    _landMarkfocus.dispose();
    _addressfocus.dispose();
    _searchController.dispose();
    FocusScope.of(context).unfocus();
  }

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          // backgroundColor: Colors.white,
          backgroundColor: Color(0xFF5ECDC9),
          // backgroundColor: Color(0xFF5ECDC9),
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF5ECDC9),
              statusBarIconBrightness: Brightness.dark, // Android
              statusBarBrightness: Brightness.light, // iOS
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF5ECDC9),
            elevation: 5,
            // Increase elevation for shadow effect
            shadowColor: Colors.black.withOpacity(0.5),
            // Customize shadow color
            leading: GestureDetector(
              onTap: () {
                print("------back---");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisitorDashboard()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Image.asset("assets/images/backtop.png"),
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Visitor List',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          body:
          // isLoading
          //     ? Center(child: Container())
          //     : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
          //     ? NoDataScreenPage()
          //     :
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 45,
                  color: Color(0xFF5ECDC9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 4),
                      Icon(Icons.calendar_month, size: 15, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text(
                        'From',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () async {
                          /// TODO Open Date picke and get a date
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          // Check if a date was picked
                          if (pickedDate != null) {
                            // Format the picked date
                            String formattedDate = DateFormat(
                              'dd/MMM/yyyy',
                            ).format(pickedDate);
                            // Update the state with the picked date
                            setState(() {
                              firstOfMonthDay = formattedDate;
                              getEmergencyTitleResponse(
                                firstOfMonthDay!,
                                lastDayOfCurrentMonth!,
                              );

                              // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            });
                            print("-----490---->>>xxx----$firstOfMonthDay");

                            /// todo here call api
                            getEmergencyTitleResponse(
                              firstOfMonthDay!,
                              lastDayOfCurrentMonth!,
                            );

                            // hrmsReimbursementStatus(
                            //   firstOfMonthDay!,
                            //   lastDayOfCurrentMonth!,
                            // );
                            // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                            print(
                              '--FirstDayOfCurrentMonth----$firstOfMonthDay',
                            );
                            // hrmsReimbursementStatus(
                            //   firstOfMonthDay!,
                            //   lastDayOfCurrentMonth!,
                            // );
                            //  print('---formPicker--$firstOfMonthDay');
                            // Call API
                            //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            // print('---formPicker--$firstOfMonthDay');

                            // Display the selected date as a toast
                            //displayToast(dExpDate.toString());
                          } else {
                            // Handle case where no date was selected
                            //displayToast("No date selected");
                          }
                        },
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          // Optional: Adjust padding for horizontal space
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Change this to your preferred color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '$firstOfMonthDay',
                              style: TextStyle(
                                color: Colors.grey,
                                // Change this to your preferred text color
                                fontSize: 12.0, // Adjust font size as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 32,
                        width: 32,
                        child: Image.asset(
                          "assets/images/datelogo.png",
                          height: 20,
                          width: 20,
                          fit:
                              BoxFit
                                  .contain, // or BoxFit.cover depending on the desired effect
                        ),
                      ),
                      //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                      SizedBox(width: 15),
                      Icon(Icons.calendar_month, size: 16, color: Colors.white),
                      SizedBox(width: 5),
                      const Text(
                        'To',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          // Check if a date was picked
                          if (pickedDate != null) {
                            // Format the picked date
                            String formattedDate = DateFormat(
                              'dd/MMM/yyyy',
                            ).format(pickedDate);
                            // Update the state with the picked date
                            setState(() {
                              lastDayOfCurrentMonth = formattedDate;
                              // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                            });
                            print(
                              "-----583---->>>xxx----$lastDayOfCurrentMonth",
                            );

                            /// todo api call here
                            getEmergencyTitleResponse(
                              firstOfMonthDay!,
                              lastDayOfCurrentMonth!,
                            );

                            // hrmsReimbursementStatus(
                            //   firstOfMonthDay!,
                            //   lastDayOfCurrentMonth!,
                            // );
                            //reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                            print(
                              '--LastDayOfCurrentMonth----$lastDayOfCurrentMonth',
                            );
                          } else {}
                        },
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          // Optional: Adjust padding for horizontal space
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Change this to your preferred color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '$lastDayOfCurrentMonth',
                              style: TextStyle(
                                color: Colors.grey,
                                // Change this to your preferred text color
                                fontSize: 12.0, // Adjust font size as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                    ),
                    // child: SearchBar(),
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey, // Outline border color
                          width: 0.2, // Outline border width
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _searchController,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Keywords',
                                    prefixIcon: Icon(Icons.search),
                                    hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),

                                  /// todo apply search button
                                  // onChanged: (query) {
                                  //   filterData(query);  // Call the filter function on text input change
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // middleHeader(context, '${widget.name}'),
                          Container(
                            color: Colors.white,
                            height:
                                MediaQuery.of(context).size.height *
                                0.8, // Adjust the height as needed
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: emergencyTitleList?.length ?? 0,
                                    itemBuilder: (context, index) {

                                      // final color = borderColors[index % borderColors.length];
                                      var status = emergencyTitleList![index]['iStatus']!;
                                      colore;
                                      if(status=="0"){
                                        colore=Colors.red;
                                      }else{
                                        colore=Colors.green;
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 15,right: 15,bottom:0,top: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // Background color
                                            border: Border.all(
                                              color: Colors.grey, // Gray outline border
                                              width: 1, // Border width
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                            // Optional rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                // Light shadow
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 1.0,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    bottom: 10,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      ClipOval(
                                                        child:
                                                            emergencyTitleList![index]['sVisitorImage'] !=
                                                                        null &&
                                                                    emergencyTitleList![index]['sVisitorImage']!
                                                                        .isNotEmpty
                                                                ? Image.network(
                                                                  emergencyTitleList![index]['sVisitorImage']!,
                                                                  width: 60,
                                                                  height: 60,
                                                                  fit: BoxFit.cover,
                                                                  errorBuilder: (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) {
                                                                    return Image.asset(
                                                                      "assets/images/visitorlist.png",
                                                                      width: 60,
                                                                      height: 60,
                                                                      fit: BoxFit.cover,
                                                                    );
                                                                  },
                                                                )
                                                                : Image.asset(
                                                                  "assets/images/visitorlist.png",
                                                                  width: 60,
                                                                  height: 60,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                      ),
                    
                                                      // ClipOval(
                                                      //   child: Image.network(
                                                      //     emergencyTitleList![index]['sVisitorImage']!,
                                                      //     width: 70,
                                                      //     height: 70,
                                                      //     fit: BoxFit.cover, // Ensures the image covers the circular area properly
                                                      //   ),
                                                      // ),
                                                      // Image.asset(
                                                      //   "assets/images/visitorlist.png",
                                                      // ),
                                                      SizedBox(width: 15),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            emergencyTitleList![index]['sVisitorName']!,
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            emergencyTitleList![index]['sPurposeVisitName']!,
                                                            style: const TextStyle(
                                                              color: Color(0xFFE69633),
                                                              // Apply hex color
                                                              fontSize: 8,
                                                            ),
                                                          ),
                                                          // Text('To Meet with Vivek Sharma',style: TextStyle(
                                                          //     color: Colors.yellow,
                                                          //     fontSize: 8
                                                          // ),),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text(
                                                                'Day ${emergencyTitleList![index]['sDayName']!}',
                                                                style: const TextStyle(
                                                                  color: Colors.black45,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                    
                                                              // Expanded(child: SizedBox()),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(child: SizedBox()),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 0,
                                                          right: 10,
                                                        ),
                                                        child: GestureDetector(
                                                          child: Container(
                                                            height: 20,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8), // Add horizontal padding
                                                            decoration: BoxDecoration(
                                                             // color: Color(0xFFC9EAFE),
                                                              color: (emergencyTitleList?[index]['iStatus']?.toString() == "0")
                                                                  ? Colors.red
                                                                  : Colors.green,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              '${emergencyTitleList?[index]['DurationTime']?.toString() ?? 'N/A'}',
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              textAlign: TextAlign.center, // Ensures proper text alignment
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  top: 0,
                                                ),
                                                child: Text(
                                                  'In/Out Time',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.watch_later_rounded,
                                                      color: Colors.black45,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 10),
                                                    const Text(
                                                      'In Time',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      emergencyTitleList?[index]['iInTime']
                                                              ?.toString() ??
                                                          'N/A',
                                                      style: const TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.watch_later_rounded,
                                                      color: Colors.black45,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 10),
                                                    const Text(
                                                      'Out Time',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      emergencyTitleList?[index]['iOutTime']
                                                              ?.toString() ??
                                                          'N/A',
                                                      style: const TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  // Opend Full Screen DialogbOX
}
