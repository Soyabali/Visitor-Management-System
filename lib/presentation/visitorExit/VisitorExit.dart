import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app/generalFunction.dart';
import '../../model/GetVisitorListModel.dart';
import '../../services/GetVisitorList_2Repo.dart';
import '../../services/VisitExitRepo.dart';
import '../resources/app_text_style.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class VisitorExitScreen extends StatefulWidget {

  final name;

  VisitorExitScreen({super.key, this.name});

  @override
  State<VisitorExitScreen> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<VisitorExitScreen> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;

  bool isLoading = true; // logic
  String? sName, sContactNo;
  var result2;
  // GeneralFunction generalFunction = GeneralFunction();

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];

  Color getRandomBorderColor() {
    final random = Random();
    return borderColors[random.nextInt(borderColors.length)];
  }


  // code
  late Future<List<GetVisitorListModel>> reimbursementStatusV3;
  List<GetVisitorListModel> _allData = []; // Holds original data
  List<GetVisitorListModel> _filteredData =
  []; // Holds filtered data

  getVisitlistRepo() async {
    reimbursementStatusV3 = GetvisitorList2Repo().getVisitorList(context);

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

  @override
  void initState() {
    // TODO: implement initState
    //getEmergencyTitleResponse();
    getVisitlistRepo();
    generateRandom20DigitNumber();

    super.initState();
  }

  // image full Screen Dialog
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

  @override
  void dispose() {
    super.dispose();
  }
  // get a random Number
  String generateRandom20DigitNumber() {
    DateTime now = DateTime.now();
    String formattedDate = now.toString().replaceAll(RegExp(r'[-:. ]'), '');

    // Extract only the required format yyyyMMddHHmmssSS
    String timestamp = formattedDate.substring(0, 16);

    // Generate a random 2-digit number (for milliseconds)
    String randomPart = Random().nextInt(100).toString().padLeft(2, '0');
    return timestamp + randomPart;

  }

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
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Color(0xFF5ECDC9),
                statusBarIconBrightness: Brightness.dark, // Android
                statusBarBrightness: Brightness.light, // iOS
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              centerTitle: true,
              backgroundColor: Color(0xFF5ECDC9),
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
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/images/backtop.png",

                    ),
                  ),
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
              elevation: 0, // Removes shadow under the AppBar
            ),

            // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
             body: Column(
               children: [
                 Expanded(
                   child: Container(
                     color: Colors.white,
                     child: FutureBuilder<List<GetVisitorListModel>>(
                       future: reimbursementStatusV3,
                       builder: (context, snapshot) {
                         // Handle API Loading State
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return const Center(child: CircularProgressIndicator());
                         }
                         // Handle API Error State
                         if (snapshot.hasError) {
                           return const Center(child: Text("No Data Found"));
                         }
                         // Ensure data is available before using it
                         if (!snapshot.hasData || snapshot.data!.isEmpty) {
                           return const Center(child: Text("No data available"));
                         }
                         // Update _filteredData from API response
                         _filteredData = snapshot.data!;
                         return ListView.builder(
                           itemCount: _filteredData.length, // Corrected Null Check
                           itemBuilder: (context, index) {
                           final leaveData = _filteredData[index];
                           return Padding(
                               padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
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
                                       crossAxisAlignment: CrossAxisAlignment.start, // Aligns text properly
                                       children: [
                                         // 📌 Visitor Image
                                         InkWell(
                                           onTap: () {
                                             openFullScreenDialog(
                                               context,
                                               leaveData.sVisitorImage,
                                               leaveData.sVisitorName,
                                             );
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 10, top: 2),
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

                                         SizedBox(width: 15), // Space after image

                                         // 📌 Visitor Details Column (Wrapped in Expanded to Prevent Overflow)
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(
                                                 leaveData.sVisitorName ?? 'N/A',
                                                 style: const TextStyle(fontSize: 14, color: Colors.black),
                                                 softWrap: true,
                                               ),
                                               Text(
                                                 'Purpose: ${leaveData.sPurposeVisitName ?? 'N/A'}',
                                                 style: const TextStyle(fontSize: 12, color: Color(0xFFE69633)),
                                                 softWrap: true,
                                               ),
                                               Text(
                                                 'Whom to Meet: ${leaveData.sWhomToMeet ?? 'N/A'}',
                                                 style: const TextStyle(fontSize: 10, color: Colors.black45),
                                                 softWrap: true,
                                               ),
                                               Text(
                                                 'Date: ${leaveData.dEntryDate ?? 'N/A'}',
                                                 style: const TextStyle(fontSize: 10, color: Colors.black45),
                                                 softWrap: true,
                                               ),
                                               Text(
                                                 '${leaveData.sDayName ?? 'N/A'}',
                                                 style: const TextStyle(fontSize: 10, color: Colors.black45),
                                                 softWrap: true,
                                               ),
                                             ],
                                           ),
                                         ),

                                         // 📌 Exit Button (Aligned Properly)
                                         Padding(
                                           padding: const EdgeInsets.only(top: 12, right: 10),
                                           child: GestureDetector(
                                             onTap: () async {
                                               print("----Exit---");
                                               var visitorID = leaveData.iVisitorId;
                                               print("----275----$visitorID");

                                               // CALL API
                                               var exitResponse = await VisitExitRepo().visitExit(context, visitorID);
                                               print("-------278-------xxx>>>---xxxx>>>-$exitResponse");
                                               result2 = exitResponse['Result'];
                                               var msg = exitResponse['Msg'];
                                               print("---result----$result2");
                                               print("---msg----$msg");

                                               if (result2 == "1") {
                                                 displayToast(msg);
                                                 getVisitlistRepo();
                                                 setState(() {});
                                               } else {
                                                 displayToast(msg);
                                               }
                                             },
                                             child: Container(
                                               height: 20,
                                               width: 70,
                                               decoration: BoxDecoration(
                                                 color: Colors.red,
                                                 borderRadius: BorderRadius.circular(10), // Rounded edges
                                               ),
                                               alignment: Alignment.center,
                                               child: const Text(
                                                 'EXIT',
                                                 style: TextStyle(
                                                   color: Colors.white,
                                                   fontSize: 10,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.only(left: 15, top: 5),
                                       child: Text(
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
               ],
             ),
          ),
        ));
  }
}
void displayToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}



