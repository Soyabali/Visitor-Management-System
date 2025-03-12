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
import '../../services/bindComplaintCategoryRepo.dart';
import '../../services/postimagerepo.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
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
          iconTheme: IconThemeData(color: Colors.white, // Change the color of the drawer icon here
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
      FocusScope.of(context).unfocus();  // Unfocus when app is paused
    }
  }

  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  late Future<List<Hrmsreimbursementstatusv3model>> reimbursementStatusV3;
  List<Hrmsreimbursementstatusv3model> _allData = [];  // Holds original data
  List<Hrmsreimbursementstatusv3model> _filteredData = [];  // Holds filtered data
  TextEditingController _takeActionController = TextEditingController();
  //

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;

  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await BindComplaintCategoryRepo().bindComplaintCategory(context);
    print('------31--xxxxx--$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }
  // Distic List

  hrmsReimbursementStatus(String firstOfMonthDay,String lastDayOfCurrentMonth) async {
    reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay, lastDayOfCurrentMonth);

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data;  // Store the data
        _filteredData = _allData;  // Initially, no filter applied
      });
    });
     // reimbursementStatusV3 = (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay,lastDayOfCurrentMonth)) as Future<List<Hrmsreimbursementstatusv3model>>;
   // _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
    print(" -----xxxxx-  reimbursementStatusList--98-----> $reimbursementStatusList");
    // setState(() {});
  }
  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData;  // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sProjectName.toLowerCase().contains(query.toLowerCase()) ||  // Filter by project name
              item.sExpHeadName.toLowerCase().contains(query.toLowerCase()) ||
              item.sStatusName.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }

  // postImage
  postimage() async {
    print('----ImageFile----$_imageFile');
    var postimageResponse = await PostImageRepo().postImage(context, _imageFile);
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

  // Uplode Id Proof with gallary
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
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
        fontSize: 16.0);
  }

  // image code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest('POST',
          Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

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
    var request = http.Request('POST',
        Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
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
    setState(() {
    });
    if(firstDayOfNextMonth!=null && lastDayOfCurrentMonth!=null){
      print('You should call api');
      //reimbursementStatusV3 = (await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!)) as Future<List<Hrmsreimbursementstatusv3model>>;
      //print('---255--$reimbursementStatusV3');
     /// reimbursementStatusList = await Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context,firstOfMonthDay!,lastDayOfCurrentMonth!);
     // _filteredData = List<Map<String, dynamic>>.from(reimbursementStatusList ?? []);
     // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
    }else{
      print('You should  not call api');
    }
  }
  // InitState
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    getCurrentdate();
    getEmergencyTitleResponse();
    hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
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
              elevation: 5, // Increase elevation for shadow effect
              shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
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
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 45,
                      color: Color(0xFF5ECDC9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 4),
                          Icon(Icons.calendar_month,size: 15,color: Colors.white),
                          const SizedBox(width: 4),
                          const Text('From',style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                          ),),
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
                                String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                // Update the state with the picked date
                                setState(() {
                                  firstOfMonthDay = formattedDate;
                                 // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                                });
                                hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                               // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                                print('--FirstDayOfCurrentMonth----$firstOfMonthDay');
                                hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                                 print('---formPicker--$firstOfMonthDay');
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
                              padding: EdgeInsets.symmetric(horizontal: 14.0), // Optional: Adjust padding for horizontal space
                              decoration: BoxDecoration(
                                color: Colors.white, // Change this to your preferred color
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '$firstOfMonthDay',
                                  style: TextStyle(
                                    color: Colors.grey, // Change this to your preferred text color
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
                              fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
                            ),
                          ),
                          //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                          SizedBox(width: 15),
                          Icon(Icons.calendar_month,size: 16,color: Colors.white),
                          SizedBox(width: 5),
                          const Text('To',style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: ()async{
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              // Check if a date was picked
                              if (pickedDate != null) {
                                // Format the picked date
                                String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                // Update the state with the picked date
                                setState(() {
                                  lastDayOfCurrentMonth = formattedDate;
                                 // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                                });
                                hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                                //reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                                print('--LastDayOfCurrentMonth----$lastDayOfCurrentMonth');
              
                              } else {
                              }
                            },
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 14.0), // Optional: Adjust padding for horizontal space
                              decoration: BoxDecoration(
                                color: Colors.white, // Change this to your preferred color
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '$lastDayOfCurrentMonth',
                                  style: TextStyle(
                                    color: Colors.grey, // Change this to your preferred text color
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
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                                      decoration: InputDecoration(
                                        hintText: 'Enter Keywords',
                                        // prefixIcon: Icon(Icons.search),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(bottom: 10), // Adjust padding to fit the icon properly
                                          child: Image.asset(
                                            'assets/images/search.png', // Replace with your image path
                                            width: 95,
                                            height: 35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
              
                                        hintStyle: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF707d83),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (query) {
                                        filterData(query);  // Call the filter function on text input change
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // middleHeader(context, '${widget.name}'),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: emergencyTitleList?.length ?? 0,
                              itemBuilder: (context, index) {
                               // final color = borderColors[index % borderColors.length];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          var iCategoryCode = emergencyTitleList![index]['sCameFrom'];
                                          var sCategoryName = emergencyTitleList![index]['sVisitorName'];
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Image.asset("assets/images/visitorlist.png"),
                                              SizedBox(width: 15),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(emergencyTitleList![index]['sVisitorName']!,style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12
                                                  ),),
                                                  Text(
                                                    emergencyTitleList![index]['sPurposeVisitName']!,
                                                    style: const TextStyle(
                                                      color: Color(0xFFE69633), // Apply hex color
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                  // Text('To Meet with Vivek Sharma',style: TextStyle(
                                                  //     color: Colors.yellow,
                                                  //     fontSize: 8
                                                  // ),),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('Day Monday',style: const TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 10
                                                      ),),
                                                      // Expanded(child: SizedBox()),
              
              
                                                    ],
                                                  )
              
                                                ],
                                              ),
                                              Expanded(child: SizedBox()),
                                              Padding(
                                                  padding: const EdgeInsets.only(top: 0,right: 10),
                                                  child: GestureDetector(
                                                    // onTap:() async{
                                                    //   print("----Exit---");
                                                    //   var visitorID = emergencyTitleList![index]['iVisitorId']!;
                                                    //   print("----275----$visitorID");
                                                    //   // here call a api
                                                    //   // var    loginMap = await LoginRepo().login(
                                                    //   //      context,
                                                    //   //      "9871950881",
                                                    //   //      "1234",
                                                    //   //    );
                                                    //   // print("----$loginMap");
                                                    //   String sOutBy = generateRandom20DigitNumber();
                                                    //   print("-----sOutBy -----$sOutBy");
                                                    //   // CALL A API
                                                    //   var exitResponse = await VisitExitRepo().visitExit(context,sOutBy,visitorID);
                                                    //   print("-------278-------xxx>>>---xxxx>>>-$exitResponse");
                                                    //   result2 = exitResponse['Result'];
                                                    //   var msg = exitResponse['Msg'];
                                                    //   print("---result----$result2");
                                                    //   print("---msg----$msg");
                                                    //   if(result2=="1"){
                                                    //     displayToast(msg);
                                                    //   }else{
                                                    //     displayToast(msg);
                                                    //   }
                                                    //
                                                    // },
                                                    child: Container(
                                                      height: 20,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        //color: Colors.blue,
                                                        color: Color(0xFFC9EAFE),
                                                        // 0xFFC9EAFE
                                                        borderRadius: BorderRadius.circular(10), // Makes the container rounded
                                                      ),
                                                      alignment: Alignment.center, // Centers the text inside
                                                      child:
                                                      const Text(
                                                        '20 min',
                                                        style: TextStyle(
                                                          color: Colors.black, // Black text color
                                                          fontSize: 10, // Adjust size as needed
                                                          fontWeight: FontWeight.bold, // Optional for bold text
                                                        ),
                                                      ),
                                                    ),
                                                  )
              
                                              )
              
                                            ],
                                          ),
                                        ),
                                        // child: ListTile(
                                        //   // leading Icon
                                        //   leading: Container(
                                        //       width: 35,
                                        //       height: 35,
                                        //       decoration: BoxDecoration(
                                        //        // color: color, // Set the dynamic color
                                        //         borderRadius: BorderRadius.circular(5),
                                        //       ),
                                        //       child: Image.asset("assets/images/visitorlist.png"),
                                        //       // child: const Icon(Icons.ac_unit,
                                        //       //   color: Colors.white,
                                        //       // )
                                        //   ),
                                        //   // Title
                                        //
                                        //   title: Text(
                                        //     emergencyTitleList![index]['sVisitorName']!,
                                        //     style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                        //   ),
                                        //   // title: Text(
                                        //   //   emergencyTitleList![index]['sVisitorName']!,
                                        //   //   style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                        //   // ),
                                        //   //  traling icon
                                        //   trailing: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       Image.asset(
                                        //           'assets/images/arrow.png',
                                        //           height: 12,
                                        //           width: 12,
                                        //           color: color
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15,top: 0),
                                      child: Text('In/Out Time Detecting',style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10
                                      ),),
                                    ),
                                    SizedBox(height: 5),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.watch_later_rounded,
                                          color: Colors.black45,
                                            size: 12,
                                          ),
                                          SizedBox(width: 10),
                                          Text('In Time',style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 10
                                          ),),
                                          Spacer(),
                                          Text('8:30',style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 10
                                          ),),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.watch_later_rounded,
                                            color: Colors.black45,
                                            size: 12,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Out Time',style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 10
                                          ),),
                                          Spacer(),
                                          Text('11:30',style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 10
                                          ),),
                                        ],
                                      ),
                                    ),
              
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey, // Gray color for the bottom line
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              
                    // Expanded(
                    //   child: Container(
                    //     child: FutureBuilder<List<Hrmsreimbursementstatusv3model>>(
                    //         future: reimbursementStatusV3,
                    //         builder: (context, snapshot) {
                    //           return ListView.builder(
                    //                itemCount: 4,
                    //               // itemBuilder: (context, index)
                    //             //  itemCount: _filteredData.length?? 0,
                    //               itemBuilder: (context, index)
                    //               {
                    //                 final leaveData = _filteredData[index];
                    //                 var sExpHeadCode = leaveData.sExpHeadCode;
                    //                // Hrmsreimbursementstatusv3model leaveData = snapshot.data![index];
                    //                 return Padding(
                    //                   padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
                    //                   child: Row(
                    //                     mainAxisAlignment: MainAxisAlignment.start,
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: <Widget>[
                    //                       Image.asset("assets/images/visitorlist.png"),
                    //                       SizedBox(width: 15),
                    //                       Column(
                    //                         mainAxisAlignment: MainAxisAlignment.start,
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: <Widget>[
                    //                           Text('Anil',style: const TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 12
                    //                           ),),
                    //                           // Text(emergencyTitleList![index]['sVisitorName']!,style: const TextStyle(
                    //                           //     color: Colors.black,
                    //                           //     fontSize: 12
                    //                           // ),),
                    //                           Text(
                    //                             'to InterView',
                    //                             style: const TextStyle(
                    //                               color: Color(0xFFE69633), // Apply hex color
                    //                               fontSize: 8,
                    //                             ),
                    //                           ),
                    //                           // Text('To Meet with Vivek Sharma',style: TextStyle(
                    //                           //     color: Colors.yellow,
                    //                           //     fontSize: 8
                    //                           // ),),
                    //                           Row(
                    //                             mainAxisAlignment: MainAxisAlignment.start,
                    //                             children: <Widget>[
                    //                               Icon(Icons.access_alarm_rounded,
                    //                                 size: 10,
                    //                                 color: Colors.red,
                    //                               ),
                    //                               SizedBox(width: 10),
                    //                               Text('9:22',style: const TextStyle(
                    //                                   color: Color(0xFFF63C74),
                    //                                   fontSize: 10
                    //                               ),),
                    //                               // Expanded(child: SizedBox()),
                    //
                    //
                    //                             ],
                    //                           )
                    //
                    //                         ],
                    //                       ),
                    //                       Expanded(child: SizedBox()),
                    //                       Padding(
                    //                           padding: const EdgeInsets.only(top: 12,right: 10),
                    //                           child: GestureDetector(
                    //                             // onTap:() async{
                    //                             //   print("----Exit---");
                    //                             //   var visitorID = emergencyTitleList![index]['iVisitorId']!;
                    //                             //   print("----275----$visitorID");
                    //                             //   // here call a api
                    //                             //   // var    loginMap = await LoginRepo().login(
                    //                             //   //      context,
                    //                             //   //      "9871950881",
                    //                             //   //      "1234",
                    //                             //   //    );
                    //                             //   // print("----$loginMap");
                    //                             //   String sOutBy = generateRandom20DigitNumber();
                    //                             //   print("-----sOutBy -----$sOutBy");
                    //                             //   // CALL A API
                    //                             //   var exitResponse = await VisitExitRepo().visitExit(context,sOutBy,visitorID);
                    //                             //   print("-------278-------xxx>>>---xxxx>>>-$exitResponse");
                    //                             //   result2 = exitResponse['Result'];
                    //                             //   var msg = exitResponse['Msg'];
                    //                             //   print("---result----$result2");
                    //                             //   print("---msg----$msg");
                    //                             //   if(result2=="1"){
                    //                             //     displayToast(msg);
                    //                             //   }else{
                    //                             //     displayToast(msg);
                    //                             //   }
                    //                             //
                    //                             // },
                    //                             child: Container(
                    //                               height: 20,
                    //                               width: 70,
                    //                               decoration: BoxDecoration(
                    //                                 //color: Colors.blue,
                    //                                 color: Color(0xFFC9EAFE),
                    //                                 // 0xFFC9EAFE
                    //                                 borderRadius: BorderRadius.circular(10), // Makes the container rounded
                    //                               ),
                    //                               alignment: Alignment.center, // Centers the text inside
                    //                               child:
                    //                               const Text(
                    //                                 'EXIT ',
                    //                                 style: TextStyle(
                    //                                   color: Colors.black, // Black text color
                    //                                   fontSize: 10, // Adjust size as needed
                    //                                   fontWeight: FontWeight.bold, // Optional for bold text
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           )
                    //
                    //                       )
                    //
                    //                     ],
                    //                   ),
                    //                 );
                    //             // return Padding(
                    //             //   padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
                    //             //   child: Card(
                    //             //     elevation: 1,
                    //             //     color: Colors.white,
                    //             //     child: Container(
                    //             //       decoration: BoxDecoration(
                    //             //         borderRadius: BorderRadius.circular(5.0),
                    //             //         border: Border.all(
                    //             //           color: Colors.grey, // Outline border color
                    //             //           width: 0.2, // Outline border width
                    //             //         ),
                    //             //       ),
                    //             //       child: Padding(
                    //             //         padding:
                    //             //         const EdgeInsets.only(left: 8, right: 8,top: 8),
                    //             //         child: Column(
                    //             //           mainAxisAlignment: MainAxisAlignment.start,
                    //             //           crossAxisAlignment:
                    //             //           CrossAxisAlignment.start,
                    //             //           children: [
                    //             //             Row(
                    //             //               mainAxisAlignment: MainAxisAlignment.start,
                    //             //               crossAxisAlignment: CrossAxisAlignment.start,
                    //             //               children: <Widget>[
                    //             //                 Container(
                    //             //                   width: 30.0,
                    //             //                   height: 30.0,
                    //             //                   decoration: BoxDecoration(
                    //             //                     borderRadius: BorderRadius.circular(15.0),
                    //             //                     border: Border.all(
                    //             //                       color: Color(0xFF255899),
                    //             //                       width: 0.5, // Outline border width
                    //             //                     ),
                    //             //                     color: Colors.white,
                    //             //                   ),
                    //             //                   child: Center(
                    //             //                     child: Text(
                    //             //                       "${1+index}",
                    //             //                       style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                    //             //                     ),
                    //             //                   ),
                    //             //                 ),
                    //             //                 SizedBox(width: 10),
                    //             //                 // Wrap the column in Flexible to prevent overflow
                    //             //                 Flexible(
                    //             //                   child: Column(
                    //             //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //             //                     children: <Widget>[
                    //             //                       Text(
                    //             //                         leaveData.sExpHeadName,
                    //             //                         style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                    //             //                         maxLines: 2, // Limits the text to 2 lines
                    //             //                         overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                    //             //                       ),
                    //             //                       SizedBox(height: 4), // Add spacing between texts if needed
                    //             //                       Padding(
                    //             //                         padding: const EdgeInsets.only(right: 10),
                    //             //                         child: Text(
                    //             //                           leaveData.sProjectName,
                    //             //                           style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
                    //             //                           maxLines: 2, // Limits the text to 2 lines
                    //             //                           overflow: TextOverflow.ellipsis, // Truncates with an ellipsis if too long
                    //             //                         ),
                    //             //                       ),
                    //             //                     ],
                    //             //                   ),
                    //             //                 ),
                    //             //                 /// todo here you should add a icon on a right hand side
                    //             //                 Spacer(),
                    //             //                // if(sExpHeadCode=="3521182900")
                    //             //                 sExpHeadCode=="3521182900" ?
                    //             //                 Padding(
                    //             //                   padding: const EdgeInsets.only(top: 10),
                    //             //                   child: InkWell(
                    //             //                     onTap: (){
                    //             //                       print('----print----');
                    //             //                       var sTranCode =  leaveData.sTranCode;
                    //             //                       print("----670----$sTranCode");
                    //             //                       // Navigator.push(
                    //             //                       //   context,
                    //             //                       //   MaterialPageRoute(builder: (context) => ConsumableItemPage(sTranCode:sTranCode)),
                    //             //                       // );
                    //             //                     },
                    //             //                     child: Row(
                    //             //                       mainAxisAlignment: MainAxisAlignment.end, // Aligns the child to the right
                    //             //                       crossAxisAlignment: CrossAxisAlignment.end,
                    //             //                       children: [
                    //             //                         Image.asset(
                    //             //                           "assets/images/aadhar.jpeg",
                    //             //                           width: 20,
                    //             //                           height: 20,
                    //             //                           fit: BoxFit.fill,
                    //             //                         ),
                    //             //                       ],
                    //             //                     ),
                    //             //                   ),
                    //             //                 )
                    //             //                 :Container()
                    //             //
                    //             //                 // Image.asset("assets/images/uplodeConsum.jpeg",
                    //             //                 // width: 20,
                    //             //                 // height: 20,
                    //             //                 // fit: BoxFit.fill,
                    //             //                 // ),
                    //             //
                    //             //               ],
                    //             //             ),
                    //             //             const SizedBox(height: 10),
                    //             //             Padding(
                    //             //               padding: const EdgeInsets.only(left: 15, right: 15),
                    //             //               child: Container(
                    //             //                 height: 0.5,
                    //             //                 color: Color(0xff3f617d),
                    //             //               ),
                    //             //             ),
                    //             //             SizedBox(height: 5),
                    //             //             Row(
                    //             //               mainAxisAlignment: MainAxisAlignment.start,
                    //             //               children: <Widget>[
                    //             //                 Container(
                    //             //                   height: 10.0,
                    //             //                   width: 10.0,
                    //             //                   decoration: BoxDecoration(
                    //             //                     color: Colors.black,
                    //             //                     // Change this to your preferred color
                    //             //                     borderRadius: BorderRadius.circular(5.0),
                    //             //                   ),
                    //             //                 ),
                    //             //                 SizedBox(width: 5),
                    //             //                 //  '‣ Sector',
                    //             //                 Text('Bill Date', style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                    //             //                 )
                    //             //               ],
                    //             //             ),
                    //             //             Padding(
                    //             //               padding: EdgeInsets.only(left: 15),
                    //             //               child: Text(
                    //             //                   leaveData.dExpDate,
                    //             //                   //item['dExpDate'] ??'',
                    //             //                   style: AppTextStyle
                    //             //                       .font12OpenSansRegularBlack45TextStyle
                    //             //               ),
                    //             //             ),
                    //             //             SizedBox(height: 5),
                    //             //             Row(
                    //             //               mainAxisAlignment: MainAxisAlignment.start,
                    //             //               children: <Widget>[
                    //             //                 Container(
                    //             //                   height: 10.0,
                    //             //                   width: 10.0,
                    //             //                   decoration: BoxDecoration(
                    //             //                     color: Colors.black,
                    //             //                     // Change this to your preferred color
                    //             //                     borderRadius: BorderRadius.circular(5.0),
                    //             //                   ),
                    //             //                 ),
                    //             //                 SizedBox(width: 5),
                    //             //                 Text('Entry At', style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                    //             //                 )
                    //             //               ],
                    //             //             ),
                    //             //             Padding(
                    //             //               padding: EdgeInsets.only(left: 15),
                    //             //               child: Text(
                    //             //                   leaveData.dEntryAt,
                    //             //                   style: AppTextStyle
                    //             //                       .font12OpenSansRegularBlack45TextStyle
                    //             //               ),
                    //             //             ),
                    //             //             SizedBox(height: 5),
                    //             //             Row(
                    //             //               mainAxisAlignment:
                    //             //               MainAxisAlignment.start,
                    //             //               children: <Widget>[
                    //             //                 Container(
                    //             //                   height: 10.0,
                    //             //                   width: 10.0,
                    //             //                   decoration: BoxDecoration(
                    //             //                     color: Colors.black,
                    //             //                     // Change this to your preferred color
                    //             //                     borderRadius: BorderRadius.circular(5.0),
                    //             //                   ),
                    //             //                 ),
                    //             //                 SizedBox(width: 5),
                    //             //                 Text('Expense Details',
                    //             //                     style: AppTextStyle.font12OpenSansRegularBlackTextStyle
                    //             //                 )
                    //             //               ],
                    //             //             ),
                    //             //             Padding(
                    //             //               padding: EdgeInsets.only(left: 15),
                    //             //               child: Text(
                    //             //                   leaveData.sExpDetails,
                    //             //                  // item['sExpDetails'] ?? '',
                    //             //                   style: AppTextStyle.font12OpenSansRegularBlack45TextStyle
                    //             //               ),
                    //             //             ),
                    //             //             SizedBox(height: 10),
                    //             //             Container(
                    //             //               height: 1,
                    //             //               width: MediaQuery.of(context).size.width - 40,
                    //             //               color: Colors.grey,
                    //             //             ),
                    //             //             SizedBox(height: 10),
                    //             //             Padding(
                    //             //               padding: const EdgeInsets.only(left: 5),
                    //             //               child: Row(
                    //             //                 mainAxisAlignment: MainAxisAlignment.start,
                    //             //                 children: [
                    //             //                   Icon(Icons.speaker_notes,
                    //             //                       size: 20,
                    //             //                       color: Colors.black),
                    //             //                   SizedBox(width: 10),
                    //             //                   Text(
                    //             //                       'Status',
                    //             //                       style: AppTextStyle
                    //             //                           .font12OpenSansRegularBlackTextStyle
                    //             //                   ),
                    //             //                   SizedBox(width: 5),
                    //             //                   const Text(
                    //             //                     ':',
                    //             //                     style: TextStyle(
                    //             //                       color: Color(0xFF0098a6),
                    //             //                       fontSize: 14,
                    //             //                       fontWeight: FontWeight.normal,
                    //             //                     ),
                    //             //                   ),
                    //             //                   SizedBox(width: 5),
                    //             //                   Expanded(
                    //             //                     child: Text(
                    //             //                       leaveData.sStatusName,
                    //             //                      // item['sStatusName'] ?? '',
                    //             //                       style: AppTextStyle
                    //             //                           .font12OpenSansRegularBlackTextStyle,
                    //             //                       maxLines: 2, // Allows up to 2 lines for the text
                    //             //                       overflow: TextOverflow.ellipsis, // Adds an ellipsis if the text overflows
                    //             //                     ),
                    //             //                   ),
                    //             //                   // Spacer(),
                    //             //                   Container(
                    //             //                     height: 30,
                    //             //                     padding: EdgeInsets.symmetric(horizontal: 16.0),
                    //             //                     decoration: BoxDecoration(
                    //             //                       color: Color(0xFF0098a6),
                    //             //                       borderRadius: BorderRadius.circular(15),
                    //             //                     ),
                    //             //                     child: Center(
                    //             //                       child: Text(
                    //             //                         leaveData.fAmount,
                    //             //                        // item['fAmount'] ?? '',
                    //             //                         style: TextStyle(
                    //             //                           color: Colors.white,
                    //             //                           fontSize: 14.0,
                    //             //                         ),
                    //             //                         maxLines: 1, // Allows up to 2 lines for the text
                    //             //                         overflow: TextOverflow.ellipsis,
                    //             //                       ),
                    //             //                     ),
                    //             //                   ),
                    //             //                 ],
                    //             //               ),
                    //             //             ),
                    //             //             SizedBox(height: 10),
                    //             //             Padding(
                    //             //               padding: const EdgeInsets.only(bottom: 10),
                    //             //               child: Row(
                    //             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             //                 // Space between the two columns
                    //             //                 children: [
                    //             //                   // First Column
                    //             //                   Expanded(
                    //             //                     child: Column(
                    //             //                       mainAxisAlignment: MainAxisAlignment.center,
                    //             //                       children: [
                    //             //                         Container(
                    //             //                           height: 40,
                    //             //                           decoration: BoxDecoration(
                    //             //                             color: Color(0xFF0098a6),
                    //             //                             // Change this to your preferred color
                    //             //                             borderRadius: BorderRadius.circular(10),
                    //             //                           ),
                    //             //                           child: GestureDetector(
                    //             //                             onTap: (){
                    //             //                               print('-----832---View Image---');
                    //             //                               print('-----832---View Image---');
                    //             //
                    //             //                               List<String> images = [
                    //             //                                 leaveData.sExpBillPhoto,
                    //             //                                 leaveData.sExpBillPhoto2,
                    //             //                                 leaveData.sExpBillPhoto3,
                    //             //                                 leaveData.sExpBillPhoto4,
                    //             //                               ].where((image) => image != null && image.isNotEmpty).toList(); // Filter out null/empty images
                    //             //
                    //             //                               var dExpDate = leaveData.dExpDate;
                    //             //                               var billDate = 'Bill Date : $dExpDate';
                    //             //                               openFullScreenDialog(context, images, billDate);
                    //             //                               },
                    //             //                             child: Row(
                    //             //                               mainAxisAlignment: MainAxisAlignment.center,
                    //             //                               children: [
                    //             //                                 Text('View Image',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                    //             //                                 Icon(Icons.arrow_forward_ios ,color: Colors.white,size: 16,),
                    //             //                               ],
                    //             //                             ),
                    //             //                           ),
                    //             //                         ),
                    //             //                       ],
                    //             //                     ),
                    //             //                   ),
                    //             //                   SizedBox(width: 2),
                    //             //                   if(leaveData.iStatus=="0")
                    //             //                     // remove
                    //             //                   Expanded(
                    //             //                     child: Column(
                    //             //                       mainAxisAlignment: MainAxisAlignment.center,
                    //             //                       children: [
                    //             //                         Container(
                    //             //                           height: 40,
                    //             //                           decoration: BoxDecoration(color: Color(0xFFE4B9AB),
                    //             //                             // Change this to your preferred color
                    //             //                             borderRadius: BorderRadius.circular(10),
                    //             //                           ),
                    //             //                           child: GestureDetector(
                    //             //                             onTap: (){
                    //             //                               print('---take action-------');
                    //             //                               /// todo call a take Action Dialog
                    //             //                               //_takeActionDialog(context);
                    //             //                                 sTranCode  = leaveData.sTranCode;
                    //             //                                 print('-------882----$sTranCode');
                    //             //                               showDialog(
                    //             //                               context: context,
                    //             //                               builder: (BuildContext context) {
                    //             //                               return _takeActionDialog(context);
                    //             //                              },
                    //             //                              );
                    //             //                              },
                    //             //                             child: Row(
                    //             //                               mainAxisAlignment: MainAxisAlignment.center,
                    //             //                               children: [
                    //             //                                 Text('Remove',style: AppTextStyle
                    //             //                                     .font14OpenSansRegularWhiteTextStyle),
                    //             //                                 Icon(Icons.arrow_forward_ios,color: Colors.white,size: 16),
                    //             //                               ],
                    //             //                             ),
                    //             //                           ),
                    //             //                         ),
                    //             //                       ],
                    //             //                     ),
                    //             //                   ),
                    //             //                   SizedBox(width: 2),
                    //             //                   // if 1 to 11 then show log
                    //             //                   if(leaveData.iStatus=="1"
                    //             //                   || leaveData.iStatus=="2"
                    //             //                   || leaveData.iStatus=="3"
                    //             //                   || leaveData.iStatus=="4"
                    //             //                   || leaveData.iStatus=="5"
                    //             //                   || leaveData.iStatus=="6"
                    //             //                   || leaveData.iStatus=="7"
                    //             //                   || leaveData.iStatus=="8"
                    //             //                   || leaveData.iStatus=="9"
                    //             //                   || leaveData.iStatus=="10"
                    //             //                   || leaveData.iStatus=="11")
                    //             //                   Expanded(
                    //             //                     child: Column(
                    //             //                       mainAxisAlignment: MainAxisAlignment.center,
                    //             //                       children: [
                    //             //                         GestureDetector(
                    //             //                           onTap :(){
                    //             //                             var projact =  leaveData.sProjectName;
                    //             //                             // var sTranCode =   item['sTranCode'] ?? '';
                    //             //                             var sTranCode =   leaveData.sTranCode;
                    //             //                             print('--project---$projact');
                    //             //                             print('--sTranCode---$sTranCode');
                    //             //
                    //             //                             // Navigator.push(
                    //             //                             //   context,
                    //             //                             //   MaterialPageRoute(builder: (context) => ReimbursementLogPage(projact,sTranCode)),
                    //             //                             // );
                    //             //                   },
                    //             //                           child: Container(
                    //             //                             height: 40,
                    //             //                             decoration: BoxDecoration(
                    //             //                               color: Color(0xFF6a94e3),
                    //             //                               // Change this to your preferred color
                    //             //                               borderRadius: BorderRadius.circular(10),
                    //             //                             ),
                    //             //                             child: GestureDetector(
                    //             //                               onTap: () {
                    //             //                                 // var projact =  item['sProjectName'] ??'';
                    //             //                               },
                    //             //                               child: Row(
                    //             //                                 mainAxisAlignment: MainAxisAlignment.center,
                    //             //                                 children: [
                    //             //                                   Text('Log',style: AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                    //             //                                   SizedBox(width: 10),
                    //             //                                   Icon(Icons.arrow_forward_ios,color: Colors.white,size: 18,),
                    //             //                                 ],
                    //             //                               ),
                    //             //                             ),
                    //             //                           ),
                    //             //                         ),
                    //             //                       ],
                    //             //                     ),
                    //             //                   ),
                    //             //
                    //             //                 ],
                    //             //               ),
                    //             //             ),
                    //             //
                    //             //           ],
                    //             //         ),
                    //             //       ),
                    //             //     ),
                    //             //   ),
                    //             // );
                    //
                    //           });
                    //         }
                    //
                    //           ),
                    //   ),
                    // ),
              
                  ]
              ),
            )),
      ),
    );
  }
  // Opend Full Screen DialogbOX

  void openFullScreenDialog(BuildContext context, List<String> imageUrls, String billDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the dialog full screen
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              // Fullscreen PageView for multiple images
              Positioned.fill(
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.contain, // Ensures the entire image is visible
                    );
                  },
                ),
              ),
              // White container with Bill Date at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        billDate,
                        style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              // Close button in the bottom-right corner
              Positioned(
                right: 16,
                bottom: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // // take a action Dialog
  Widget _takeActionDialog(BuildContext context) {

    TextEditingController _takeAction = TextEditingController(); // Text controller for the TextFormField

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 220, // Adjusted height to accommodate the TextFormField and Submit button
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Remove Reimbursement',
                  style: AppTextStyle.font16OpenSansRegularRedTextStyle,
                ),
                SizedBox(height: 10),
                // TextFormField for entering data
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                      child: TextFormField(
                        controller: _takeAction,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true, // Enable background color
                          fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter a value';
                        //   }
                        //   final intValue = int.tryParse(value);
                        //   if (intValue == null || intValue <= 0) {
                        //     return 'Enter an amount greater than 0';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                SizedBox(height: 15),
                // Submit button
                InkWell(
                  onTap: ()async{
                    var takeAction = _takeAction.text.trim();
                    print('-----1102--$takeAction');
                    print(sTranCode);

                    // Check if the input is not empty
                    if (takeAction != null && takeAction != '') {
                      print('---Call Api-----');

                      // Make API call here
                     // var loginMap = await Reimbursementstatustakeaction().reimbursementTakeAction(context, sTranCode);
                      //print('---418----$loginMap');

                      // setState(() {
                      //   result = "${loginMap[0]['Result']}";
                      //   msg = "${loginMap[0]['Msg']}";
                      // }
                     // );

                      print('---1114----$result');
                      print('---1115----$msg');

                      // Check the result of the API call
                      if (result == "1") {
                        // Close the current dialog and show a success dialog
                        Navigator.of(context).pop();

                        // Show the success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildDialogSucces2(context, msg); // A new dialog for showing success
                          },
                        );
                        print('-----1123---');
                      } else if (result == "0") {
                        // Keep the dialog open and show an error message (if needed)
                        // You can display an error message in the same dialog without dismissing it
                        displayToast(msg);  // Optionally, show a toast message to indicate failure

                        // Optionally clear the input field if needed
                        // _takeAction.clear();  // Do not clear to allow retrying
                      }
                    } else {
                      // Handle the case where no input is provided
                      displayToast("Enter remarks");
                    }

                    },
                  child: Container(
                    //width: double.infinity,
                    // Make container fill the width of its parent
                    height: AppSize.s45,
                    padding: EdgeInsets.all(AppPadding.p5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // Background color using HEX value
                      borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                    ),
                    //  #00b3c7
                    child: Center(
                      child: Text(
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     String enteredText = _textController.text;
                //     if (enteredText.isNotEmpty) {
                //       print('Submitted: $enteredText');
                //     }
                //     // Perform any action you need on submit
                //    // Navigator.of(context).pop(); // Close the dialog
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Adjust button size
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15), // Rounded corners for button
                //     ),
                //     backgroundColor: Colors.blue, // Button background color
                //   ),
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/addreimbursement.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // sucessDialog
  Widget _buildDialogSucces2(BuildContext context,String msg) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 190,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).pop();
                         // call api again
                         hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ExpenseManagement()),
                        // );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/sussess.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
