import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app/generalFunction.dart';
import '../../services/UpdateVisitorStatusRepo.dart';
import '../../services/VisitExitRepo.dart';
import '../../services/VisitorDetailsRepo.dart';
import '../../services/VisitorStatusRepo.dart';
import '../../services/bindCityzenWardRepo.dart';
import '../../services/bindComplaintCategoryRepo.dart';
import '../../services/loginRepo.dart';
import '../resources/app_text_style.dart';
import '../nodatavalue/NoDataValue.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class UpdateVisitorStatus extends StatefulWidget {

  final name;
  UpdateVisitorStatus({super.key, this.name});

  @override
  State<UpdateVisitorStatus> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<UpdateVisitorStatus> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;

  bool isLoading = true; // logic
  String? sName, sContactNo;
  var result2;
  List<dynamic> wardList = [];
  var _dropDownWardValue;
  var _selectedWardId2;
  var result,msg;

  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await VisitorDetailsRepo().visitorDetail(context);
    print('------39--xxxxx--$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }
  // update list
  bindPurposeWidget() async {
    wardList = await VisitorStatusRepo().visitorStatus();
    print(" -----xxxxx-  -----53--xxxxx-----> $wardList");
    setState(() {});
  }

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

  // updateVisitor
  Widget _purposeBindData() {
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
                    text: "Purpose Of Visit",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWardValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWardValue = newValue;
                    wardList.forEach((element) {
                      if (element["sStatusName"] == _dropDownWardValue) {
                        _selectedWardId2 = element['iStatusCode'];

                      }
                    });
                    print("----wardCode----163---xxx--$_selectedWardId2");
                  });
                },
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sStatusName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sStatusName'].toString(),
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

  @override
  void initState() {
    // TODO: implement initState
    getEmergencyTitleResponse();
    generateRandom20DigitNumber();
    bindPurposeWidget();
    super.initState();
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
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
    // final Random random = Random();
    // String randomNumber = '';
    //
    // for (int i = 0; i < 10; i++) {
    //   randomNumber += random.nextInt(12).toString();
    // }
    // return randomNumber;
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
                  'Update Visitor Status',
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
                                          emergencyTitleList![index]['sContactNo']!,
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
                                            const Icon(Icons.access_alarm_rounded,
                                              size: 10,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text(emergencyTitleList![index]['dLastVisit']!,style: const TextStyle(
                                                color: Color(0xFFF63C74),
                                                fontSize: 10
                                            ),),
                                            // Expanded(child: SizedBox()),


                                          ],
                                        )

                                      ],
                                    ),
                                   // Expanded(child: SizedBox()),
                                    // Padding(
                                    //     padding: const EdgeInsets.only(top: 12,right: 10),
                                    //     child: GestureDetector(
                                    //       onTap:() async{
                                    //         print("----Exit---");
                                    //         var visitorID = emergencyTitleList![index]['iVisitorId']!;
                                    //         print("----275----$visitorID");
                                    //         // here call a api
                                    //         // var    loginMap = await LoginRepo().login(
                                    //         //      context,
                                    //         //      "9871950881",
                                    //         //      "1234",
                                    //         //    );
                                    //         // print("----$loginMap");
                                    //         String sOutBy = generateRandom20DigitNumber();
                                    //         print("-----sOutBy -----$sOutBy");
                                    //         // CALL A API
                                    //         var exitResponse = await VisitExitRepo().visitExit(context,sOutBy,visitorID);
                                    //         print("-------278-------xxx>>>---xxxx>>>-$exitResponse");
                                    //         result2 = exitResponse['Result'];
                                    //         var msg = exitResponse['Msg'];
                                    //         print("---result----$result2");
                                    //         print("---msg----$msg");
                                    //         if(result2=="1"){
                                    //           displayToast(msg);
                                    //         }else{
                                    //           displayToast(msg);
                                    //         }
                                    //
                                    //       },
                                    //       child: Container(
                                    //         height: 20,
                                    //         width: 70,
                                    //         decoration: BoxDecoration(
                                    //           //color: Colors.blue,
                                    //           color: Color(0xFFC9EAFE),
                                    //           // 0xFFC9EAFE
                                    //           borderRadius: BorderRadius.circular(10), // Makes the container rounded
                                    //         ),
                                    //         alignment: Alignment.center, // Centers the text inside
                                    //         child:
                                    //         const Text(
                                    //           'EXIT ',
                                    //           style: TextStyle(
                                    //             color: Colors.black, // Black text color
                                    //             fontSize: 10, // Adjust size as needed
                                    //             fontWeight: FontWeight.bold, // Optional for bold text
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     )
                                    //
                                    // ),


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
                          SizedBox(height: 5),
                          _purposeBindData(),
                          SizedBox(height: 5),
                          Container(
                            child:  GestureDetector(
                              onTap: () async {
                                var sContactNo = emergencyTitleList![index]['sContactNo']!;
                                // _selectedWardId2
                                     print("----sContanctNo---$sContactNo");
                                     print("----_selectedWardId2---$_selectedWardId2");
                                     // call api here

                                     if(sContactNo!=null && _selectedWardId2!=null){
                                       print('----call the api');

                                     var  loginMap = await UpdateVisitorStatusRepo().updateVisitor(
                                         context,
                                         sContactNo,
                                         _selectedWardId2

                                     );
                                    result = "${loginMap['Result']}";
                                   msg = "${loginMap['Msg']}";
                                   print('------474--xxxx--->>>>--$result');
                                   print('------475--xxxx--->>>>--$msg');
                                   if(result=="1"){
                                     displayToast(msg);
                                     Navigator.pop(context);
                                     // navigate
                                   }else{
                                     displayToast(msg);
                                   }


                                     }else{
                                       displayToast("Please choose the purpose of your visit.");
                                       print('----Api is not call---');
                                     }
                                     },




                              child: Image.asset('assets/images/submit.png', // Replace with your image path
                                fit: BoxFit.fill,
                              ),
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



