import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../app/generalFunction.dart';
import '../resources/app_text_style.dart';
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
  List<Hrmsreimbursementstatusv3model> _filteredData = []; // Holds filtered data
  TextEditingController _takeActionController = TextEditingController();

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;

  hrmsReimbursementStatus(
    String firstOfMonthDay,
    String lastDayOfCurrentMonth,
  ) async {
    reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo()
        .hrmsReimbursementStatusList(
          context,
          firstOfMonthDay,
          lastDayOfCurrentMonth,
        );

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
    setState(() {
    });
    print("--------94--->>>>-----$_filteredData");
  }
  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = List.from(_allData); // Reset to all data
      } else {
        _filteredData = _allData.where((item) {
          return item.sVisitorName.toLowerCase().contains(query.toLowerCase()) ||
              item.sUserName.toLowerCase().contains(query.toLowerCase()) ||
              item.sDayName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // void filterData(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredData = List.from(_allData); // Avoid modifying reference
  //     } else {
  //       _filteredData = _allData.where((item) {
  //         return item.sVisitorName.toLowerCase().contains(query.toLowerCase()) ||
  //             item.sUserName.toLowerCase().contains(query.toLowerCase()) ||
  //             item.sDayName.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

  // void filterData(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredData = _allData; // Show all data if search query is empty
  //     } else {
  //       _filteredData =
  //           _allData.where((item) {
  //             return item.sVisitorName.toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ) || // Filter by project name
  //                 item.sUserName.toLowerCase().contains(query.toLowerCase()) ||
  //                 item.sDayName.toLowerCase().contains(query.toLowerCase());
  //             // Filter by employee name
  //           }).toList();
  //     }
  //   });
  // }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

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
      hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
      setState(() {

      });
      print('---272---->>>>>  xxxxxxx--$reimbursementStatusV3');
    } else {
      print('You should  not call api');
    }
  }
  // openFULL screenDialog
  void openFullScreenDialog(
      BuildContext context, String imageUrl, String billDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the dialog full screen
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              // Fullscreen Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Adjust the image to fill the dialog
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
                      Flexible(
                        child: Text(
                          billDate,
                          style:
                          AppTextStyle.font12OpenSansRegularBlackTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    // getLocation();
    getCurrentdate();

    hrmsReimbursementStatus(firstOfMonthDay!, lastDayOfCurrentMonth!);
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                            hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);

                            // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });
                          print("-----490---->>>xxx----$firstOfMonthDay");

                          /// todo here call api
                          hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
                            style: const TextStyle(
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
                             hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                          });
                          print("-----583---->>>xxx----$lastDayOfCurrentMonth");
                          /// todo api call here
                          hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);

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
                            style: const TextStyle(
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
                                onChanged: filterData,
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
              // here you should bind the list
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: FutureBuilder<List<Hrmsreimbursementstatusv3model>>(
                    future: reimbursementStatusV3,
                    builder: (context, snapshot) {
                      // Handle API Loading State
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const Center(child: CircularProgressIndicator());
                      // }
                      // // Handle API Error State
                      // if (snapshot.hasError) {
                      //   return const Center(child: Text("Failed to load data"));
                      // }
                      // // Ensure data is available before using it
                      // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      //   return const Center(child: Text("No data available"));
                      // }
                      // // Assign data only once
                      // if (_allData.isEmpty) {
                      //   _allData = snapshot.data!;
                      //   _filteredData = _allData;
                      // }
                      // // Update _filteredData from API response
                      // _filteredData = snapshot.data!;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Failed to load data"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No data available"));
                      }

                      // Assign API data only once to avoid resetting _filteredData
                      if (_allData.isEmpty) {
                        _allData = snapshot.data!;
                        _filteredData = List.from(_allData);
                      }
                      return ListView.builder(
                        itemCount: _filteredData.length, // Corrected Null Check
                        itemBuilder: (context, index) {
                          final leaveData = _filteredData[index];

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          openFullScreenDialog(
                                            context,
                                            leaveData.sVisitorImage,
                                            leaveData.sVisitorName,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 2),
                                          child: ClipOval(
                                            child: (leaveData.sVisitorImage != null && leaveData.sVisitorImage.isNotEmpty)
                                                ? Image.network(
                                              leaveData.sVisitorImage,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
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
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            leaveData.sVisitorName ?? 'N/A',
                                            style: const TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                          Text(
                                            'Purpose: ${leaveData.sPurposeVisitName ?? 'N/A'}',
                                            style: const TextStyle(fontSize: 12, color: Color(0xFFE69633)),
                                          ),
                                          Text(
                                            'Whom to Meet: ${leaveData.sWhomToMeet ?? 'N/A'}',
                                            style: const TextStyle(fontSize: 10, color: Colors.black45),
                                          ),
                                          Text(
                                            'Date: ${leaveData.dEntryDate ?? 'N/A'}',
                                            style: const TextStyle(fontSize: 10, color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Container(
                                          height: 20,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: (leaveData.iStatus?.toString() == "0") ? Colors.red : Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            leaveData.DurationTime?.toString() ?? 'N/A',
                                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 5),
                                    child: const Text(
                                      'In/Out Time',
                                      style: TextStyle(fontSize: 10, color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.watch_later_rounded, color: Colors.black45, size: 12),
                                        SizedBox(width: 10),
                                        const Text('In Time', style: TextStyle(fontSize: 10, color: Colors.black45)),
                                        Spacer(),
                                        Text(leaveData.iInTime?.toString() ?? 'N/A', style: const TextStyle(fontSize: 10, color: Colors.black45)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.watch_later_rounded, color: Colors.black45, size: 12),
                                        SizedBox(width: 10),
                                        const Text('Out Time', style: TextStyle(fontSize: 10, color: Colors.black45)),
                                        Spacer(),
                                        Text(leaveData.iOutTime?.toString() ?? 'N/A', style: const TextStyle(fontSize: 10, color: Colors.black45)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),


              // Expanded(
              //   child: Container(
              //     color: Colors.white,
              //     child: FutureBuilder<List<Hrmsreimbursementstatusv3model>>(
              //       future: reimbursementStatusV3,
              //       builder: (context, snapshot) {
              //         return ListView.builder(
              //
              //           itemCount: _filteredData.length ?? 0,
              //           itemBuilder: (context, index) {
              //             final leaveData = _filteredData[index];
              //             return Padding(
              //               padding: const EdgeInsets.only(
              //                 left: 15,
              //                 right: 15,
              //                 bottom: 0,
              //                 top: 15,
              //               ),
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   // Background color
              //                   border: Border.all(
              //                     color: Colors.grey, // Gray outline border
              //                     width: 1, // Border width
              //                   ),
              //                   borderRadius: BorderRadius.circular(10),
              //                   // Optional rounded corners
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: Colors.black.withOpacity(0.1),
              //                       // Light shadow
              //                       spreadRadius: 1,
              //                       blurRadius: 5,
              //                       offset: Offset(0, 3), // Shadow position
              //                     ),
              //                   ],
              //                 ),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                         vertical: 1.0,
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(
              //                           top: 10,
              //                           left: 10,
              //                           bottom: 10,
              //                         ),
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: <Widget>[
              //                             InkWell(
              //                               onTap:(){
              //                                 var images = leaveData.sVisitorImage;
              //                                 var names = leaveData.sVisitorName;
              //                                 // open full ScreenDialog
              //                                 openFullScreenDialog(
              //                                     context,
              //                                     images,
              //                                     names
              //                                 );
              //                                 },
              //                               child: ClipOval(
              //                                 child:
              //                                 leaveData.sVisitorImage!=null &&
              //                                 leaveData.sVisitorImage.isNotEmpty
              //                                         ? Image.network(
              //                                           leaveData.sVisitorImage,
              //                                          // emergencyTitleList![index]['sVisitorImage']!,
              //                                           width: 60,
              //                                           height: 60,
              //                                           fit: BoxFit.cover,
              //                                           errorBuilder: (
              //                                             context,
              //                                             error,
              //                                             stackTrace,
              //                                           ) {
              //                                             return Image.asset(
              //                                               "assets/images/visitorlist.png",
              //                                               width: 60,
              //                                               height: 60,
              //                                               fit: BoxFit.cover,
              //                                             );
              //                                           },
              //                                         )
              //                                         : Image.asset(
              //                                           "assets/images/visitorlist.png",
              //                                           width: 60,
              //                                           height: 60,
              //                                           fit: BoxFit.cover,
              //                                         ),
              //                               ),
              //                             ),
              //                             SizedBox(width: 15),
              //                             Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Text(
              //                                   leaveData.sVisitorName,
              //                                   // emergencyTitleList![index]['sVisitorName']!,
              //                                   style: const TextStyle(
              //                                     color: Colors.black,
              //                                     fontSize: 14,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   'Purpose : ${leaveData.sPurposeVisitName}',
              //                                   // 'Purpose : ${emergencyTitleList![index]['sPurposeVisitName']!}',
              //                                   style: const TextStyle(
              //                                     color: Color(0xFFE69633),
              //                                     // Apply hex color
              //                                     fontSize: 12,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   'Whom to Meet : ${leaveData.sWhomToMeet}',
              //                                   // 'Whom to Meet : ${emergencyTitleList![index]['sWhomToMeet']!}',
              //                                   style: const TextStyle(
              //                                     color: Colors.black45,
              //                                     fontSize: 10,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   'Date : ${leaveData.dEntryDate}',
              //                                   // 'Date : ${emergencyTitleList![index]['dEntryDate']!}',
              //                                   style: const TextStyle(
              //                                     color: Colors.black45,
              //                                     fontSize: 10,
              //                                   ),
              //                                 ),
              //                                 Row(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment.start,
              //                                   children: <Widget>[
              //                                     Text(
              //                                       '${leaveData.sDayName}',
              //                                       // '${emergencyTitleList![index]['sDayName']!}',
              //                                       style: const TextStyle(
              //                                         color: Colors.black45,
              //                                         fontSize: 10,
              //                                       ),
              //                                     ),
              //
              //                                     // Expanded(child: SizedBox()),
              //                                   ],
              //                                 ),
              //                               ],
              //                             ),
              //                             Expanded(child: SizedBox()),
              //                             Padding(
              //                               padding: const EdgeInsets.only(
              //                                 top: 0,
              //                                 right: 10,
              //                               ),
              //                               child: GestureDetector(
              //                                 child: Row(
              //                                   mainAxisAlignment: MainAxisAlignment.end, // Aligns the container to the right
              //                                   children: [
              //                                     Flexible( // Prevents overflow by resizing the container
              //                                       child: Container(
              //                                         height: 20,
              //                                         padding: const EdgeInsets.symmetric(horizontal: 8),
              //                                         decoration: BoxDecoration(
              //                                           color: (leaveData.iStatus.toString() == "0") ? Colors.red : Colors.green,
              //                                           borderRadius: BorderRadius.circular(10),
              //                                         ),
              //                                         alignment: Alignment.center,
              //                                         child: Text(
              //                                           '${leaveData.DurationTime?.toString() ?? 'N/A'}',
              //                                           style: const TextStyle(
              //                                             color: Colors.white,
              //                                             fontSize: 10,
              //                                             fontWeight: FontWeight.bold,
              //                                           ),
              //                                           textAlign: TextAlign.center,
              //                                           overflow: TextOverflow.ellipsis, // Prevents overflow
              //                                           maxLines: 1, // Keeps text in a single line
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                                 // child: Container(
              //                                 //   height: 20,
              //                                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //                                 //   // Add horizontal padding
              //                                 //   decoration: BoxDecoration(
              //                                 //     // color: Color(0xFFC9EAFE),
              //                                 //     color: (leaveData.iStatus.toString() == "0")
              //                                 //             ? Colors.red
              //                                 //             : Colors.green,
              //                                 //     borderRadius: BorderRadius.circular(10),
              //                                 //   ),
              //                                 //   alignment: Alignment.center,
              //                                 //   child: Text(
              //                                 //     '${leaveData.DurationTime?.toString() ?? 'N/A'}',
              //                                 //     // '${emergencyTitleList?[index]['DurationTime']?.toString() ?? 'N/A'}',
              //                                 //     style: const TextStyle(
              //                                 //       color: Colors.white,
              //                                 //       fontSize: 10,
              //                                 //       fontWeight: FontWeight.bold,
              //                                 //     ),
              //                                 //     textAlign: TextAlign.center, // Ensures proper text alignment
              //                                 //   ),
              //                                 // ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     const Padding(
              //                       padding: EdgeInsets.only(left: 15, top: 0),
              //                       child: Text(
              //                         'In/Out Time',
              //                         style: TextStyle(
              //                           color: Colors.red,
              //                           fontSize: 10,
              //                         ),
              //                       ),
              //                     ),
              //                     SizedBox(height: 5),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                         left: 10,
              //                         right: 10,
              //                         bottom: 10,
              //                       ),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.start,
              //                         children: [
              //                           const Icon(
              //                             Icons.watch_later_rounded,
              //                             color: Colors.black45,
              //                             size: 12,
              //                           ),
              //                           SizedBox(width: 10),
              //                           const Text(
              //                             'In Time',
              //                             style: TextStyle(
              //                               color: Colors.black45,
              //                               fontSize: 10,
              //                             ),
              //                           ),
              //                           Spacer(),
              //                           Text(
              //                             leaveData.iInTime
              //                                     .toString()
              //                                     ?.toString() ??
              //                                 'N/A',
              //                             style: const TextStyle(
              //                               color: Colors.black45,
              //                               fontSize: 10,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                     SizedBox(height: 5),
              //                     Padding(
              //                       padding: const EdgeInsets.only(
              //                         left: 10,
              //                         right: 10,
              //                         bottom: 10,
              //                       ),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.start,
              //                         children: [
              //                           const Icon(
              //                             Icons.watch_later_rounded,
              //                             color: Colors.black45,
              //                             size: 12,
              //                           ),
              //                           SizedBox(width: 10),
              //                           const Text(
              //                             'Out Time',
              //                             style: TextStyle(
              //                               color: Colors.black45,
              //                               fontSize: 10,
              //                             ),
              //                           ),
              //                           Spacer(),
              //                           Text(
              //                             leaveData.iOutTime
              //                                     .toString()
              //                                     ?.toString() ??
              //                                 'N/A',
              //                             //emergencyTitleList?[index]['iOutTime']?.toString() ?? 'N/A',
              //                             style: const TextStyle(
              //                               color: Colors.black45,
              //                               fontSize: 10,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             );
              //
              //
              //           },
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Opend Full Screen DialogbOX
}
