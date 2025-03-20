
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/DataForUpdateVisitorApprovalRepo.dart';
import '../../services/VisitorApprovedDeniedRepo.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class VisitorList extends StatelessWidget {
  const VisitorList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorListPage(),
    );
  }
}

class VisitorListPage extends StatefulWidget {
  const VisitorListPage({super.key});

  @override
  State<VisitorListPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VisitorListPage> {

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<Map<String, dynamic>>? recentVisitorList;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true; // logic


  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode passWordfocus = FocusNode();

  bool passwordVisible = false;
  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  String? sUserName,sContactNo;
  var token,firebaseToken,iUserId;
  var firebasetitle,firebasebody,loginUserID;
  var sVisitorName,sCameFrom,sPurposeVisitName,sVisitorImage;
  var sApprovalStatus,iVisitorId;
  String? iUserId2;

  GeneralFunction generalFunction = GeneralFunction();


  @override
  void initState() {
    getDataFromLoacalDataBase();
    super.initState();

  }
  // full image Diallog
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
  // foregroudn dasdboard
  getDataFromLoacalDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? iUserId2 = prefs.getString('iUserId');
     loginUserID = prefs.getString('iUserId');
    if (iUserId2!=null){
      // thenn call api
      dataforapproval(iUserId2);
    }
  }

  // token forward api
  dataforapproval(iUserId) async {
    var   dataforApproval = await DataForupdateVisitorApprovalRepo().dataForUpdateVisitorApproval(context,iUserId);
    print("------->>>>>---xx--94----$dataforApproval");
    var result = dataforApproval['Result'];
    if(result=="1"){
      var msg = dataforApproval['Msg'];
      setState(() {
         sVisitorName = dataforApproval['Data'][0]['sVisitorName'];
        sCameFrom = dataforApproval['Data'][0]['sCameFrom'];
        sPurposeVisitName = dataforApproval['Data'][0]['sPurposeVisitName'];
        sVisitorImage = dataforApproval['Data'][0]['sVisitorImage'];
        iVisitorId = dataforApproval['Data'][0]['iVisitorId'];
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false; // Even if no data, stop loading
      });
    }

  }

  // Approved aND Rejected Functionality

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: generalFunction.drawerFunction_2(context,"$sUserName","$sContactNo"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard
        },
        child: Stack(
          children: [
            // Full-screen background image
            Positioned(
              top: 0, // Start from the top
              left: 0,
              right: 0,
              height:
              MediaQuery.of(context).size.height * 0.7, // 70% of screen height
              child: Image.asset('assets/images/bg.png', // Replace with your image path
                fit: BoxFit.cover, // Covers the area properly
              ),
            ),
            Positioned(
                top: 70,
                left: 20,
                child: GestureDetector(
                    onTap: () {
                      //   VisitorDashboard
                      //Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VisitorDashboard()),
                      );
                     // Navigator.pop(context); // Navigates back when tapped
                    },
                    child: Image.asset("assets/images/backtop.png")
                )
            ),
            // Top image (height: 80, margin top: 20)
            Positioned(
              top: 120,
              left: 35,
              right: 35,
              child: InkWell(
                onTap: (){
                  // open image full screen dialog
                  openFullScreenDialog(
                      context,
                      sVisitorImage,
                      sVisitorName
                     );

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Adjust for rounded corners
                  child: Container(
                    width: 200,
                    height: 200,
                    child: sVisitorImage != null && sVisitorImage.isNotEmpty
                        ? Image.network(
                      sVisitorImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover, // Ensures proper fit
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/visitorlist.png",
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      "assets/images/visitorlist.png",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 335,
              left: 15,
              right: 15,
              child: Material(
                // elevation: 0.1, // Apply elevation
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.transparent, // Keep the Material transparent
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: GlassmorphicContainer(
                      height: 250,
                      width: MediaQuery.of(context).size.width - 30,
                      borderRadius: 20, // Keep it 20 for consistency
                      blur: 10,
                      alignment: Alignment.center,
                      border: 1, // Keep a smaller border for aesthetics
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6), // More opacity to enhance whiteness
                          Colors.white.withOpacity(0.5), // Less contrast to avoid gray tint
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6), // Match with main gradient
                          // Colors.white.withOpacity(0.5),
                          //  Colors.white24.withOpacity(0.2),
                          Colors.white24.withOpacity(0.5),
                          //  Colors.white70.withOpacity(0.2),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter, // Aligns child widgets from the top
                        children: [
                          Positioned(
                              top: 20, // Place text at the top of the screen
                              left: 15,
                              right: 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity, // Full width
                                    height: 35, // Fixed height
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC9EAFE), // Background color
                                      borderRadius: BorderRadius.circular(17), // Rounded border radius
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26, // Shadow color
                                          blurRadius: 3, // Softness of the shadow
                                          spreadRadius: 2, // How far the shadow spreads
                                          offset: Offset(2, 4), // Offset from the container (X, Y)
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center, // Centers text inside the container
                                    child: const Text(
                                      "Visitor Detail",
                                      style: TextStyle(
                                        color: Colors.black45, // Text color
                                        fontSize: 16, // Font size
                                        fontWeight: FontWeight.bold, // Bold text
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              )
                          ),
                          Positioned(
                            top: 90,
                            left: 15,
                            right: 15,
                            child: Row(
                              children: <Widget>[
                                // Fixed width label
                                const SizedBox(
                                  width: 120, // Ensures labels take the same width
                                  child: Text(
                                    "Visitor Name",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Colon (keeps it aligned)
                                const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 10), // Space between colon and value
                                // Expanding visitor name
                                Expanded(
                                  child: Text(
                                   // sVisitorName,
                                    isLoading ? "Loading..." : (sVisitorName ?? "N/A"),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // second
                          Positioned(
                            top: 115,
                            left: 15,
                            right: 15,
                            child: Row(
                              children: <Widget>[
                                // Fixed width label
                                const SizedBox(
                                  width: 120, // Ensures labels take the same width
                                  child: Text(
                                    "From",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Colon (keeps it aligned)
                                const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 10), // Space between colon and value
                                // Expanding "From" value
                                Expanded(
                                  child: Text(
                                   // sCameFrom,
                                    isLoading ? "Loading..." : (sCameFrom ?? "N/A"),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // third Visit
                          Positioned(
                            top: 140,
                            left: 15,
                            right: 15,
                            child: Row(
                              children: <Widget>[
                                // Fixed width label
                                const SizedBox(
                                  width: 120, // Ensures labels take the same width
                                  child: Text(
                                    "Purpose Of Visit",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Colon (keeps it aligned)
                                const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 10), // Space between colon and value
                                // Expanding "From" value
                                Expanded(
                                  child: Text(
                                    //sPurposeVisitName,
                                    isLoading ? "Loading..." : (sPurposeVisitName ?? "N/A"),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 175,
                            left: 15,
                            right: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 45, // Increased height for better visibility
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      /// todo call api here
                                      ///   VisitorApprovedDeniedRepo
                                      var sApprovalStatus="1";
                                      print("ivisitorID :----$iVisitorId");
                                      print("logintime id :----$loginUserID");
                                      print("---status:--$sApprovalStatus");
                                      // iActionBy  -- logintime id
                                      var   vectorApprovalDenied = await VisitorApprovedDeniedRepo().visitrorApprovedDenied(context,iVisitorId,sApprovalStatus,loginUserID);
                                      print("-----449---$vectorApprovalDenied");
                                     // var result = '$vectorApprovalDenied'
                                      var result = vectorApprovalDenied['Result'];
                                      var msg = vectorApprovalDenied['Msg'];
                                      if(result=="1"){
                                        displayToast(msg);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                        );
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                      backgroundColor: Colors.green, // Button color
                                    ),
                                    child: const Text(
                                      "Approve",
                                      style: TextStyle(
                                        fontSize: 14, // Increased font size
                                        fontWeight: FontWeight.bold, // Bold text for better visibility
                                        color: Colors.white, // Ensure contrast
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),
                                Container(
                                  height: 45, // Increased height for better visibility
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      var sApprovalStatus="2";
                                      print("ivisitorID :----$iVisitorId");
                                      print("logintime id :----$loginUserID");
                                      print("---status:--$sApprovalStatus");
                                      // iActionBy  -- logintime id
                                      var   vectorApprovalDenied = await VisitorApprovedDeniedRepo().visitrorApprovedDenied(context,iVisitorId,sApprovalStatus,loginUserID);
                                      print("-----449---$vectorApprovalDenied");

                                      var result = vectorApprovalDenied['Result'];
                                      var msg = vectorApprovalDenied['Msg'];
                                      if(result=="1"){
                                        displayToast(msg);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                        );
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                      backgroundColor: Colors.red, // Button color
                                    ),
                                    child: const Text(
                                      "Denied",
                                      style: TextStyle(
                                        fontSize: 14, // Increased font size
                                        fontWeight: FontWeight.bold, // Bold text for better visibility
                                        color: Colors.white, // Ensure contrast
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 75, // Maintain same left padding
              right: 75, // Maintain same right padding
              bottom: 5, // Set distance from bottom
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Container(
                  // width: MediaQuery.of(context).size.width-50,
                  child: Image.asset('assets/images/companylogo.png', // Replace with your image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// toast code
void displayToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
