import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/loader_helper.dart';
import '../../services/PostCitizenComplaintRepo.dart';
import '../../services/baseurl.dart';
import '../../services/bindCityzenWardRepo.dart';
import '../../services/whoomToMeet.dart';
import '../resources/app_text_style.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SearchVisitorDetails extends StatelessWidget {

  const SearchVisitorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchVisitorDetailsPage(),
    );
  }
}
class SearchVisitorDetailsPage extends StatefulWidget {
  const SearchVisitorDetailsPage({super.key});

  @override
  State<SearchVisitorDetailsPage> createState() => _VisitorEntryScreenState();
}

class _VisitorEntryScreenState extends State<SearchVisitorDetailsPage> {

  final _formKey = GlobalKey<FormState>();

  List<dynamic> wardList = [];
  List<dynamic> whomToMeet = [];
  var _dropDownWardValue;
  var _dropDownWhomToValue;
  var _selectedWardId2;
  var _selectedWhomToMeetValue;
  var result,msg;
  File? image;
  var uplodedImage;

  // bind data on a DropDown
  bindPurposeWidget() async {
    wardList = await BindCityzenWardRepo().getbindWard();
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }
  // Whom To MEET
  whoomToWidget() async {
    whomToMeet = await BindWhomToMeetRepo().getbindWhomToMeet();
    print(" -----xxxxx-  wardList--52---> $whomToMeet");
    setState(() {});
  }


  int _visitorCount = 1;
  final _nameController = TextEditingController();
  final _ContactNoController = TextEditingController();
  final _cameFromController = TextEditingController();
  final _purposeOfVisitController = TextEditingController();
  final _whomToMeetController = TextEditingController();
  final _purposeController = TextEditingController();

  late FocusNode nameControllerFocus,contactNoFocus,cameFromFocus,
      purposeOfVisitFocus,whomToMeetFocus,purposeFocus,approvalStatusFocus,
      idProofWithPhotoFocus,itemCarriedFocus;
  //late FocusNode contactNoFocus;

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
  // uplode images code
  Future<void> uploadImage(String token, File imageFile) async {
    print("--------225---tolen---$token");
    print("--------226---imageFile---$imageFile");
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostMultipleImage/PostMultipleImage";
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
        setState(() {

        });
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
    bindPurposeWidget();
    whoomToWidget();
    generateRandom20DigitNumber();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _ContactNoController.dispose();
    _cameFromController.dispose();
    _purposeOfVisitController.dispose();
    _whomToMeetController.dispose();
    _purposeController.dispose();
    // focus dispose
    nameControllerFocus.dispose();
    contactNoFocus.dispose();
    cameFromFocus.dispose();

    super.dispose();
  }
  // increment and decrement number functionality
  void _incrementVisitorCount() {
    setState(() {
      _visitorCount++;
    });
  }

  void _decrementVisitorCount() {
    setState(() {
      if (_visitorCount > 1) {
        _visitorCount--;
      }
    });
  }
  // random Number

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

  // Code Whom To Meet
  Widget _WhomToMeet() {
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
                    text: "Whom To Meet",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWhomToValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWhomToValue = newValue;
                    whomToMeet.forEach((element) {
                      if (element["sUserName"] == _dropDownWhomToValue) {
                        _selectedWhomToMeetValue = element['iUserId'];

                      }
                    });
                    print("----whom To meet --149--xx-->>>..xxx.---$_selectedWhomToMeetValue");
                  });
                },
                items: whomToMeet.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sUserName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sUserName'].toString(),
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
  // Code Purpose
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
                      if (element["sPurposeVisitName"] == _dropDownWardValue) {
                        _selectedWardId2 = element['iPurposeVisitID'];

                      }
                    });
                    print("----wardCode----215---xxx--$_selectedWardId2");
                  });
                },
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sPurposeVisitName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sPurposeVisitName'].toString(),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0, // Start from the top
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
              child: Image.asset('assets/images/bg.png', // Replace with your image path
                fit: BoxFit.cover, // Covers the area properly
              ),
            ),
            // backButton
            Positioned(
                top: 70,
                left: 20,
                child: GestureDetector(
                    onTap: () {
                      //   VisitorDashboard
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VisitorDashboard()),
                      );
                      // Navigator.pop(context); // Navigates back when tapped
                    },
                    child: Image.asset("assets/images/backtop.png")
                )
            ),
            Positioned(
              top: 110,
              left: 0, // Required to enable alignment
              right: 0, // Required to enable alignment
              child: Align(
                alignment: Alignment.topCenter, // Centers horizontally
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,
                      right: 15
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          InkWell(
                            onTap: (){
                              print("-----Pick images----");
                              pickImage();
                            },
                            child: uplodedImage == null || uplodedImage!.isEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(75), // Half of width/height for a circle
                              child: Image.asset(
                                'assets/images/human.png', // Default Image
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.network(
                                uplodedImage!, // Uploaded Image
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/human.png',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),

                            // child: Container(
                            //   child: Image.asset('assets/images/human.png',
                            //    height: 120,
                            //     width: 120,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                          ),
                          SizedBox(height: 15),
                          const Center(
                            child: Text('Pick an image',style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),),
                          ),
                          SizedBox(height: 25),
                          // apply here GlassMorphism
                          //  Visitor Name Fields
                          GlassmorphicContainer(
                            height: 470,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: 20, // Keep it 20 for consistency
                            blur: 10,
                            alignment: Alignment.center,
                            border: 1, // Keep a smaller border for aesthetics
                            linearGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.6), // More opacity to enhance whiteness
                                Colors.white.withOpacity(0.5), // Less contrast to avoid gray tint
                                // Colors.white.withOpacity(0.2),
                                // //Colors.white38.withOpacity(0.2),
                                // Colors.white24.withOpacity(0.2),
                                //Colors.white.withOpacity(0.2),
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
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Container(
                                    // Full width
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
                                      "Visitor Entry",
                                      style: TextStyle(
                                        color: Colors.black45, // Text color
                                        fontSize: 16, // Font size
                                        fontWeight: FontWeight.bold, // Bold text
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // TextFormField
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Set the background color to white
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              bottomLeft: Radius.circular(4.0),
                                            ),
                                          ),
                                          child: TextFormField(
                                            controller: _nameController,
                                            style: const TextStyle(color: Colors.black), // Set the text color to black
                                            decoration: const InputDecoration(
                                              labelText: 'Visitor Name',
                                              labelStyle: TextStyle(color: Colors.black),
                                              // hintText: 'Enter Contact No',
                                              hintStyle: TextStyle(color: Colors.black),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // 2. Text with Matching Border
                                      // Container(
                                      //   height: 50,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white, // Set the background color to white
                                      //     border: Border.all(color: Colors.grey),
                                      //     borderRadius: const BorderRadius.only(
                                      //       topLeft: Radius.circular(4.0),
                                      //       bottomLeft: Radius.circular(4.0),
                                      //     ),
                                      //   ),
                                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                                      //   child: Text(
                                      //     '$_visitorCount',
                                      //     style: TextStyle(fontSize: 16),
                                      //   ),
                                      // ),
                                      // // 3. SizedBox (for Spacing)
                                      // const SizedBox(width: 2.0),
                                      // // 4. Increment IconButton
                                      // IconButton(
                                      //   onPressed: _incrementVisitorCount,
                                      //   icon: const Icon(Icons.add,color: Colors.green,),
                                      // ),
                                      // // 5. Decrement IconButton
                                      // IconButton(
                                      //   onPressed: _decrementVisitorCount,
                                      //   icon: const Icon(Icons.remove,color: Colors.red,),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // contact Number Fields
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Set the background color to white
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        bottomLeft: Radius.circular(4.0),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _ContactNoController,
                                      keyboardType: TextInputType.phone, // Set keyboard type to phone
                                      style: const TextStyle(color: Colors.black),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Contact No',
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return 'Enter mobile number';
                                      //   }
                                      //   if (value.length > 1 && value.length < 10) {
                                      //     return 'Enter 10 digit mobile number';
                                      //   }
                                      //   return null;
                                      // },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                //  CameFrom Visit TextField
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Set the background color to white
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        bottomLeft: Radius.circular(4.0),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _cameFromController,
                                      style: const TextStyle(color: Colors.black), // Set the text color to black
                                      decoration: const InputDecoration(
                                        labelText: 'Came From',
                                        labelStyle: TextStyle(color: Colors.black),
                                        // hintText: 'Enter Contact No',
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                _purposeBindData(),
                                SizedBox(height: 5),
                                // Whom of Visit
                                _WhomToMeet(),
                                // SizedBox(height: 5),
                                SizedBox(height: 45),
                                Container(
                                  child:  GestureDetector(
                                    onTap: () async {
                                      //
                                      //  iEntryBy

                                      String iVisitorId = generateRandom20DigitNumber();
                                      var visitorName = _nameController.text.trim();
                                      //   _visitorCount
                                      var contactNo = _ContactNoController.text.trim();
                                      var cameFrom = _cameFromController.text.trim();
                                      var purposeOfVisit = _purposeOfVisitController.text.trim();
                                      //   _selectedWhomToMeetValue
                                      //  _selectedWardId2


                                      if (_formKey.currentState!.validate() &&
                                          visitorName.isNotEmpty &&
                                          _visitorCount!=null &&
                                          contactNo.isNotEmpty &&
                                          cameFrom.isNotEmpty &&
                                          _selectedWhomToMeetValue !=null &&
                                          _selectedWardId2!=null
                                      ) {
                                        print("----visitor Name : $visitorName");
                                        print("----visitor Count : $_visitorCount");
                                        print("----contact No : $contactNo");
                                        print("----cameFrom  : $cameFrom");
                                        print("----purposeOfVisit  : $purposeOfVisit");
                                        print("----_selectedWhomToMeetValue  : $_selectedWhomToMeetValue");
                                        print("----_selectedWardId2  : $_selectedWardId2");

                                        var  postComplaintResponse = await PostCitizenComplaintRepo().postComplaint(
                                            context,
                                            visitorName,
                                            _visitorCount,
                                            contactNo,
                                            cameFrom,
                                            _selectedWhomToMeetValue,
                                            _selectedWardId2,
                                            iVisitorId,
                                            uplodedImage

                                        );
                                        print('----502--->>>>>---$postComplaintResponse');
                                        result = postComplaintResponse['Result'];
                                        msg = postComplaintResponse['Msg'];


                                        // loginMap = await LoginRepo().login(
                                        //   context,
                                        //   phone,
                                        //   password,
                                        // );
                                        // result = "${loginMap['Result']}";
                                        // msg = "${loginMap['Msg']}";

                                        // if(result=="1"){
                                        //   // to store the fetch data into the local database
                                        //   var iUserId = loginMap["Data"][0]["iUserId"].toString();
                                        //   var sUserName = loginMap["Data"][0]["sUserName"].toString();
                                        //   var sContactNo = loginMap["Data"][0]["sContactNo"].toString();
                                        //   var sToken = loginMap["Data"][0]["sToken"].toString();
                                        //   var iUserType = loginMap["Data"][0]["iUserType"].toString();
                                        //   var dLastLoginAt = loginMap["Data"][0]["dLastLoginAt"].toString();
                                        //
                                        //
                                        //   // to store the value into the sharedPreference
                                        //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                        //   prefs.setString('iUserId',iUserId).toString();
                                        //   prefs.setString('sUserName',sUserName).toString();
                                        //   prefs.setString('sContactNo',sContactNo).toString();
                                        //   prefs.setString('sToken',sToken).toString();
                                        //   prefs.setString('iUserType',iUserType).toString();
                                        //   prefs.setString('dLastLoginAt',dLastLoginAt).toString();
                                        //
                                        //   Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                        //         (Route<dynamic> route) => false, // Remove all previous routes
                                        //   );
                                        //
                                        // }else{
                                        //   displayToast(msg);
                                        //
                                        // }
                                        // if (result == "1") {
                                        //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                        //   prefs.setString('sToken', "${loginMap['Data'][0]['sToken']}",
                                        //
                                        //   );
                                        //
                                        //   if ((lat == null && lat == '') ||
                                        //       (long == null && long == '')) {
                                        //     displayToast("Please turn on Location");
                                        //   } else {
                                        //
                                        //     // Navigator.pushReplacement(
                                        //     //   context,
                                        //     //   MaterialPageRoute(
                                        //     //     builder:
                                        //     //         (context) => VisitorDashboard(),
                                        //     //   ),
                                        //     // );
                                        //
                                        //   }
                                        // } else {
                                        //   displayToast(msg);
                                        // }
                                      } else {
                                        if (_nameController.text.isEmpty) {
                                          // phoneNumberfocus.requestFocus();
                                          displayToast("Please Enter Visitor Name");
                                        } else if (_ContactNoController.text.isEmpty) {
                                          // passWordfocus.requestFocus();
                                          displayToast("Please Enter Contact No");
                                        }else if(_cameFromController.text.isEmpty){
                                          displayToast("Please Enter Came From");
                                        }else if(_selectedWhomToMeetValue==null){
                                          displayToast("Please Select Whom To Meet");
                                        }else if(_selectedWardId2==null){
                                          displayToast("Please Select Purpose");
                                        }else{

                                        }
                                      }
                                      if(result=="1"){
                                        displayToast(msg);
                                        //to jump the DashBoard
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => VisitorDashboard(),
                                          ),
                                        );
                                      }else{
                                        // show toast
                                        displayToast(msg);

                                      }
                                    },
                                    child: Image.asset('assets/images/submit.png', // Replace with your image path
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SizedBox(height: 45),
                          Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15),
                            child: Container(
                              // width: MediaQuery.of(context).size.width-50,
                              child: Image.asset('assets/images/companylogo.png', // Replace with your image path
                                fit: BoxFit.fill,
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
    );
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
}

