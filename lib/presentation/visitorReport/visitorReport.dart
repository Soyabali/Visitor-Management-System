import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../app/generalFunction.dart';
import '../../services/bindComplaintCategoryRepo.dart';
import '../resources/app_text_style.dart';
import '../nodatavalue/NoDataValue.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class VisitorReportScreen extends StatefulWidget {

  final name;
  VisitorReportScreen({super.key, this.name});

  @override
  State<VisitorReportScreen> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<VisitorReportScreen> {

  GeneralFunction generalFunction = GeneralFunction();

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
  //
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;

  final List<Map<String, dynamic>> itemList2 = [
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'ICICI BANK CC PAYMENT',
      'subtitle': 'Utility & Bill Payments',
      'transactions': '1 transaction',
      'amount': ' 7,86,698',
      'temple': 'Fire Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'APTRONIX',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 1,69,800',
      'temple': 'Police'
    },
    {
      //'leadingIcon': Icons.account_box,
      'leadingIcon': 'assets/images/shopping-bag2.png',
      'title': 'MICROSOFT INDIA',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 30,752',
      'temple': 'Women Help'
    },
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'SARVODAYA HOSPITAL U O',
      'subtitle': 'Medical',
      'transactions': '1 transaction',
      'amount': '@ 27,556',
      'temple': 'Medical Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Other Important Numbers'
    },
  ];

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
  // filterData

  @override
  void initState() {
    // TODO: implement initState
    getEmergencyTitleResponse();
    super.initState();
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
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
                  child: Image.asset("assets/images/backtop.png",

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
            body: isLoading
                ? Center(child: Container())
                : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
                ? NoDataScreenPage()
                :
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
                      final color = borderColors[index % borderColors.length];
                      return Column(
                        children: <Widget>[
                          // here you should put search bar code here.
                          Container(
                            height: 45,
                            color: Color(0xFF2a697b),
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
                                      /// todo call here api
                                      ///
                                      //hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
                                      // reimbursementStatusV3 = Hrmsreimbursementstatusv3Repo().hrmsReimbursementStatusList(context, firstOfMonthDay!, lastDayOfCurrentMonth!);
                                      print('--FirstDayOfCurrentMonth----$firstOfMonthDay');
                                     // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
                                SizedBox(width: 6),
                                Container(
                                  height: 32,
                                  width: 32,
                                  child: Image.asset(
                                    "assets/images/reimicon_2.png",
                                    fit: BoxFit.contain, // or BoxFit.cover depending on the desired effect
                                  ),
                                ),
                                //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                                SizedBox(width: 8),
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
                                      /// todo call here api
                                     // hrmsReimbursementStatus(firstOfMonthDay!,lastDayOfCurrentMonth!);
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
                          // Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                          //     // child: SearchBar(),
                          //     child: Container(
                          //       height: 45,
                          //       padding: EdgeInsets.symmetric(horizontal: 10.0),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(5.0),
                          //         border: Border.all(
                          //           color: Colors.grey, // Outline border color
                          //           width: 0.2, // Outline border width
                          //         ),
                          //         color: Colors.white,
                          //       ),
                          //       child: Center(
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(top: 0),
                          //           child: Row(
                          //             children: [
                          //               Expanded(
                          //                 child: TextFormField(
                          //                   controller: _searchController,
                          //                   autofocus: true,
                          //                   decoration: const InputDecoration(
                          //                     hintText: 'Enter Keywords',
                          //                     prefixIcon: Icon(Icons.search),
                          //                     hintStyle: TextStyle(
                          //                         fontFamily: 'Montserrat',
                          //                         color: Color(0xFF707d83),
                          //                         fontSize: 14.0,
                          //                         fontWeight: FontWeight.bold),
                          //                     border: InputBorder.none,
                          //                   ),
                          //                   onChanged: (query) {filterData(query);  // Call the filter function on text input change
                          //                   },
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 0),

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
                                            Icon(Icons.access_alarm_rounded,
                                              size: 10,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text(emergencyTitleList![index]['iInTime']!,style: const TextStyle(
                                                color: Color(0xFFF63C74),
                                                fontSize: 10
                                            ),),
                                            // Expanded(child: SizedBox()),


                                          ],
                                        )

                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 12,right: 10),
                                        child: GestureDetector(
                                          onTap:(){

                                            print("----Exit---");
                                          },
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
                                            child: const Text(
                                              'EXIT',
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

          ),
        ));
  }
}



