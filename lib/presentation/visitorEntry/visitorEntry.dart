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

class VisitorEntry extends StatelessWidget {

  const VisitorEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorEntryScreen(),
    );
  }
}
class VisitorEntryScreen extends StatefulWidget {

  const VisitorEntryScreen({super.key});

  @override
  State<VisitorEntryScreen> createState() => _VisitorEntryScreenState();
}

class _VisitorEntryScreenState extends State<VisitorEntryScreen> {

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

  String? phoneError;
  String? nameError;
  bool _isTextEntered = false;

  // textfield property
  // String? validateName(String value) {
  //   if (value.trim().isEmpty) {
  //     return "Name cannot be empty";
  //   }
  //
  //   final nameRegex = RegExp(r'^[A-Za-z_ ]+$');
  //   if (!nameRegex.hasMatch(value)) {
  //     return "Invalid characters in name";
  //   }
  //
  //   return null;
  // }
  // String capitalizeEachWord(String input) {
  //   return input
  //       .split(' ')
  //       .map((word) {
  //     if (word.isEmpty) return '';
  //     return word[0].toUpperCase() + word.substring(1).toLowerCase();
  //   })
  //    .join(' ');
  // }

  String formatInputText(String input) {
    final separators = RegExp(r'[ _]'); // match space or underscore

    return input
        .split(separators)
        .map(
          (word) =>
      word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '',
    )
        .join(' ')
        .replaceAllMapped(RegExp(r'([ _])'), (match) => match.group(1)!);
  }



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
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostMultipleImage/PostMultipleImage";
    var uploadImageApi = "$baseURL$endPoint";
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST', Uri.parse('$uploadImageApi'),
      );
      request.headers['token'] = token;
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

  // visitorName validation
  String? validateName(String value) {
    if (value.isEmpty) return 'Enter Name';

    // Rule 1: Length
    if (value.length > 30) return 'Name must be at most 30 characters';

    // Rule 2: Only letters, space, underscore allowed
    if (!RegExp(r'^[a-zA-Z_ ]+$').hasMatch(value)) {
      return 'Only letters and underscore (_) allowed';
    }

    // Rule 3: First character must be uppercase
    if (!RegExp(r'^[A-Z]').hasMatch(value)) {
      return 'First letter must be capital';
    }

    // Rule 4: Capital after space or underscore
    for (int i = 1; i < value.length; i++) {
      if ((value[i - 1] == ' ' || value[i - 1] == '_') && !RegExp(r'[A-Z]').hasMatch(value[i])) {
        return 'First letter after space or underscore must be capital';
      }

      if (i > 1 && value[i - 1] != ' ' && value[i - 1] != '_' && RegExp(r'[A-Z]').hasMatch(value[i])) {
        return 'Only first letter and after space/underscore should be capital';
      }
    }

    return null;
  }
  // capitilize name
  String capitalizeName(String value) {
    // Split by space or underscore
    List<String> parts = value.split(RegExp(r'[_ ]'));
    List<String> capitalizedParts = parts.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Rebuild using the original delimiters
    String result = '';
    int j = 0;
    for (int i = 0; i < value.length; i++) {
      if (value[i] == ' ' || value[i] == '_') {
        result += value[i];
      } else {
        result += capitalizedParts[j];
        i += capitalizedParts[j].length - 1;
        j++;
      }
    }

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    bindPurposeWidget();
    whoomToWidget();
    generateRandom20DigitNumber();
    nameControllerFocus= FocusNode();
    contactNoFocus= FocusNode();
    cameFromFocus= FocusNode();
    _cameFromController.addListener(() {
      setState(() {
        _isTextEntered = _cameFromController.text.isNotEmpty;
      });
    });
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
      if (_visitorCount <10) { // Allow only if less than 10
        _visitorCount++;
      }
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
         // color: Color(0xFFf2f3f5),
          color: Colors.white,
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
         // color: Color(0xFFf2f3f5),
          color: Colors.white,
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
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
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
                  top: 60,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VisitorDashboard()),
                      );
                    },
                    child: SizedBox(
                      width: 50, // Set proper width
                      height: 50, // Set proper height
                      child: Image.asset("assets/images/backtop.png"),
                    ),
                  ),
                ),
                Positioned(
                  top: 85,
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
                                    height: 125,
                                    width: 125,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.network(
                                    uplodedImage!, // Uploaded Image
                                    height: 125,
                                    width: 125,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/human.png',
                                        height: 125,
                                        width: 125,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              // apply here GlassMorphism
                              //  Visitor Name Fields
                              GlassmorphicContainer(
                                height: 540,
                                width: MediaQuery.of(context).size.width,
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
                                    SizedBox(height: 20),
                                    // visitor name
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: TextFormField(
                                      controller: _nameController,
                                      autofocus: true,
                                      focusNode: nameControllerFocus,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(color: Colors.black),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_ ]')),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: "Visitor Name",
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        errorText: nameError?.isEmpty == true ? null : nameError,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0), // Rounded corners applied here
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400, // light gray
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        String formatted = capitalizeName(value);
                                        if (_nameController.text != formatted) {
                                          _nameController.value = TextEditingValue(
                                            text: formatted,
                                            selection: TextSelection.collapsed(offset: formatted.length),
                                          );
                                        }
                                        setState(() {
                                          nameError = validateName(formatted);
                                        });
                                      },
                                      validator: (value) => validateName(value ?? ""),
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 15, right: 15),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       border: Border.all(color: Colors.grey),
                                  //       borderRadius: const BorderRadius.only(
                                  //         topLeft: Radius.circular(4.0),
                                  //         bottomLeft: Radius.circular(4.0),
                                  //       ),
                                  //     ),
                                  //     child: TextFormField(
                                  //       controller: _nameController,
                                  //       autofocus: true,
                                  //       focusNode: nameControllerFocus,
                                  //       textInputAction: TextInputAction.next,
                                  //       style: const TextStyle(color: Colors.black),
                                  //       inputFormatters: [
                                  //         LengthLimitingTextInputFormatter(30),
                                  //         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_ ]')),
                                  //       ],
                                  //       decoration: InputDecoration(
                                  //         labelText: "Visitor Name",
                                  //         border: const OutlineInputBorder(),
                                  //         errorText: nameError?.isEmpty == true ? null : nameError,
                                  //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  //         // Adjust padding instead of fixed height
                                  //       ),
                                  //       onChanged: (value) {
                                  //         String formatted = capitalizeName(value);
                                  //         if (_nameController.text != formatted) {
                                  //           _nameController.value = TextEditingValue(
                                  //             text: formatted,
                                  //             selection: TextSelection.collapsed(offset: formatted.length),
                                  //           );
                                  //         }
                                  //         setState(() {
                                  //           nameError = validateName(formatted);
                                  //         });
                                  //       },
                                  //       validator: (value) => validateName(value ?? ""),
                                  //     ),
                                  //   ),
                                  // ),


                                  // Padding(
                                    //   padding: const EdgeInsets.only(left: 15,right: 15),
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.white, // Set the background color to white
                                    //       border: Border.all(color: Colors.grey),
                                    //       borderRadius: const BorderRadius.only(
                                    //         topLeft: Radius.circular(4.0),
                                    //         bottomLeft: Radius.circular(4.0),
                                    //       ),
                                    //     ),
                                    //     child: SizedBox(
                                    //       height: 75,
                                    //       child: TextFormField(
                                    //         controller: _nameController,
                                    //         autofocus: true,
                                    //         focusNode: nameControllerFocus,
                                    //         textInputAction: TextInputAction.next,
                                    //         style: const TextStyle(color: Colors.black),
                                    //         inputFormatters: [
                                    //           LengthLimitingTextInputFormatter(30),
                                    //           FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_ ]')),
                                    //         ],
                                    //         decoration: InputDecoration(
                                    //           labelText: "Visitor Name",
                                    //           border: const OutlineInputBorder(),
                                    //           // prefixIcon: const Icon(
                                    //           //   Icons.person,
                                    //           //   color: Color(0xFF255899),
                                    //           // ),
                                    //           errorText: nameError,
                                    //         ),
                                    //         onChanged: (value) {
                                    //           String formatted = capitalizeName(value);
                                    //           if (_nameController.text != formatted) {
                                    //             _nameController.value = TextEditingValue(
                                    //               text: formatted,
                                    //               selection: TextSelection.collapsed(offset: formatted.length),
                                    //             );
                                    //           }
                                    //           setState(() {
                                    //             nameError = validateName(formatted);
                                    //           });
                                    //         },
                                    //         validator: (value) => validateName(value ?? ""),
                                    //       ),
                                    //     ),
                                    //
                                    //   ),
                                    // ),
                                    SizedBox(height: 15),
                                    // contact Number Fields
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: TextFormField(
                                      controller: _ContactNoController,
                                      focusNode: contactNoFocus,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: "Mobile Number",
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        errorText: phoneError?.isEmpty == true ? null : phoneError,

                                        // Default border
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),

                                        // When enabled but not focused
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),

                                        // When focused
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: Colors.black.withOpacity(0.25), // Black with 25% opacity
                                            width: 2,
                                          ),
                                        ),

                                        // Error state
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.red, width: 2),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.isEmpty) {
                                            phoneError = 'Enter mobile number';
                                          } else if (value.length > 10) {
                                            phoneError = 'Mobile number must be 10 digits';
                                          } else if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                            phoneError = 'The mobile number is not valid.';
                                          } else if (RegExp(r'^0+$').hasMatch(value)) {
                                            phoneError = 'The mobile number is not valid.';
                                          } else if (value.length < 10) {
                                            phoneError = 'Mobile number must be 10 digits';
                                          } else {
                                            phoneError = null;
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter mobile number';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be 10 digits';
                                        }
                                        if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                          return 'The mobile number is not valid.';
                                        }
                                        if (RegExp(r'^0+$').hasMatch(value)) {
                                          return 'The mobile number is not valid.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 15, right: 15),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       border: Border.all(color: Colors.grey),
                                  //       borderRadius: const BorderRadius.only(
                                  //         topLeft: Radius.circular(4.0),
                                  //         bottomLeft: Radius.circular(4.0),
                                  //       ),
                                  //     ),
                                  //     child: TextFormField(
                                  //       controller: _ContactNoController,
                                  //       focusNode: contactNoFocus,
                                  //       textInputAction: TextInputAction.next,
                                  //       keyboardType: TextInputType.phone,
                                  //       inputFormatters: [
                                  //         LengthLimitingTextInputFormatter(10),
                                  //         FilteringTextInputFormatter.digitsOnly,
                                  //       ],
                                  //       decoration: InputDecoration(
                                  //         labelText: "Mobile Number",
                                  //         border: const OutlineInputBorder(),
                                  //         errorText: phoneError?.isEmpty == true ? null : phoneError,
                                  //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  //         // dynamic spacing instead of fixed height
                                  //       ),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           if (value.isEmpty) {
                                  //             phoneError = 'Enter mobile number';
                                  //           } else if (value.length > 10) {
                                  //             phoneError = 'Mobile number must be 10 digits';
                                  //           } else if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                  //             phoneError = 'The mobile number is not valid.';
                                  //           } else if (RegExp(r'^0+$').hasMatch(value)) {
                                  //             phoneError = 'The mobile number is not valid.';
                                  //           } else if (value.length < 10) {
                                  //             phoneError = 'Mobile number must be 10 digits';
                                  //           } else {
                                  //             phoneError = null;
                                  //           }
                                  //         });
                                  //       },
                                  //       validator: (value) {
                                  //         if (value == null || value.isEmpty) {
                                  //           return 'Enter mobile number';
                                  //         }
                                  //         if (value.length != 10) {
                                  //           return 'Mobile number must be 10 digits';
                                  //         }
                                  //         if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                  //           return 'The mobile number is not valid.';
                                  //         }
                                  //         if (RegExp(r'^0+$').hasMatch(value)) {
                                  //           return 'The mobile number is not valid.';
                                  //         }
                                  //         return null;
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),

                                  // Padding(
                                    //   padding: const EdgeInsets.only(left: 15,right: 15),
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.white, // Set the background color to white
                                    //       border: Border.all(color: Colors.grey),
                                    //       borderRadius: const BorderRadius.only(
                                    //         topLeft: Radius.circular(4.0),
                                    //         bottomLeft: Radius.circular(4.0),
                                    //       ),
                                    //     ),
                                    //     child: SizedBox(
                                    //       height: 75,
                                    //       child: TextFormField(
                                    //         controller: _ContactNoController,
                                    //         focusNode: contactNoFocus,
                                    //         textInputAction: TextInputAction.next,
                                    //         keyboardType: TextInputType.phone,
                                    //         inputFormatters: [
                                    //           LengthLimitingTextInputFormatter(10),
                                    //           FilteringTextInputFormatter.digitsOnly,
                                    //         ],
                                    //         decoration: InputDecoration(
                                    //           labelText: "Mobile Number",
                                    //           border: const OutlineInputBorder(),
                                    //           // prefixIcon: const Icon(
                                    //           //   Icons.phone,
                                    //           //   color: Color(0xFF255899),
                                    //           // ),
                                    //           errorText: phoneError,
                                    //         ),
                                    //         onChanged: (value) {
                                    //           setState(() {
                                    //             if (value.isEmpty) {
                                    //               phoneError = 'Enter mobile number';
                                    //             } else if (value.length > 10) {
                                    //               phoneError = 'Mobile number must be 10 digits';
                                    //             } else if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                    //               phoneError = 'The mobile number is not valid.';
                                    //             } else if (RegExp(r'^0+$').hasMatch(value)) {
                                    //               phoneError = 'The mobile number is not valid.';
                                    //             } else if (value.length < 10) {
                                    //               phoneError = 'Mobile number must be 10 digits';
                                    //             } else {
                                    //               phoneError = null;
                                    //             }
                                    //           });
                                    //         },
                                    //         validator: (value) {
                                    //           if (value == null || value.isEmpty) {
                                    //             return 'Enter mobile number';
                                    //           }
                                    //           if (value.length != 10) {
                                    //             return 'Mobile number must be 10 digits';
                                    //           }
                                    //           if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                    //             return 'The mobile number is not valid.';
                                    //           }
                                    //           if (RegExp(r'^0+$').hasMatch(value)) {
                                    //             return 'The mobile number is not valid.';
                                    //           }
                                    //           return null;
                                    //         },
                                    //       ),
                                    //     ),
                                    //
                                    //   ),
                                    // ),

                                    SizedBox(height: 15),
                                    //  CameFrom Visit TextField
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: TextFormField(
                                      controller: _cameFromController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50), // increased limit for full address
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r"[a-zA-Z0-9\s,.\-#/]+"),
                                        ),
                                      ],
                                      style: const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

                                        // Custom label with red asterisk
                                        label: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'From',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '*',
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),

                                        // Borders (same as Name & Mobile fields)
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: Colors.black.withOpacity(0.25), // black 25% opacity
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(color: Colors.red, width: 2),
                                        ),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Address is required';
                                        }
                                        if (value.trim().length < 4) {
                                          return 'Please enter a valid address';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        final formatted = formatInputText(value);
                                        if (formatted != value) {
                                          final cursorPos = formatted.length;
                                          _cameFromController.value = TextEditingValue(
                                            text: formatted,
                                            selection: TextSelection.collapsed(offset: cursorPos),
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  // Padding(
                                    //   padding: const EdgeInsets.only(left: 15,right: 15),
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.white, // Set the background color to white
                                    //       border: Border.all(color: Colors.grey),
                                    //       borderRadius: const BorderRadius.only(
                                    //         topLeft: Radius.circular(4.0),
                                    //         bottomLeft: Radius.circular(4.0),
                                    //       ),
                                    //     ),
                                    //     child: TextFormField(
                                    //       controller: _cameFromController,
                                    //      // autofocus: true,
                                    //       inputFormatters: [
                                    //         LengthLimitingTextInputFormatter(50), // increased limit for full address
                                    //         FilteringTextInputFormatter.allow(
                                    //           RegExp(r"[a-zA-Z0-9\s,.\-#/]+"),
                                    //         ),
                                    //       ],
                                    //       style: const TextStyle(color: Colors.black),
                                    //       decoration: const InputDecoration(
                                    //         border: InputBorder.none,
                                    //         contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                    //         label:const Row(
                                    //           mainAxisSize: MainAxisSize.min, // Ensures compact label size
                                    //           children: [
                                    //             Text(
                                    //               'From',
                                    //               style: TextStyle(color: Colors.black),
                                    //             ),
                                    //             SizedBox(width: 4), // Adds spacing between text and asterisk
                                    //             Text(
                                    //               '*',
                                    //               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       autovalidateMode: AutovalidateMode.onUserInteraction,
                                    //       validator: (value) {
                                    //         if (value == null || value.trim().isEmpty) {
                                    //           return 'Address is required';
                                    //         }
                                    //         if (value.trim().length < 4) {
                                    //           return 'Please enter a valid address';
                                    //         }
                                    //         return null;
                                    //       },
                                    //       onChanged: (value) {
                                    //         final formatted = formatInputText(value);
                                    //         if (formatted != value) {
                                    //           final cursorPos = formatted.length;
                                    //           _cameFromController.value = TextEditingValue(
                                    //             text: formatted,
                                    //             selection: TextSelection.collapsed(offset: cursorPos),
                                    //           );
                                    //         }
                                    //       },
                                    //     ),
                                    //   ),
                                    // ),

                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,right: 15),
                                      child: _purposeBindData(),
                                    ),
                                    SizedBox(height: 5),
                                    // Whom of Visit
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,right: 15),
                                      child: _WhomToMeet(),
                                    ),
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

                                          if (_formKey.currentState!.validate() &&
                                              visitorName.isNotEmpty &&
                                              _visitorCount!=null &&
                                              contactNo.isNotEmpty &&
                                              cameFrom.isNotEmpty &&
                                              _selectedWhomToMeetValue !=null &&
                                              _selectedWardId2!=null &&
                                              uplodedImage!=null
                                          ) {
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

                                          } else {
                                            if(uplodedImage==null){
                                              displayToast("Please click the images");
                                            }
                                            else if (_nameController.text.isEmpty) {
                                            } else if (_ContactNoController.text.isEmpty) {
                                            }else if(_cameFromController.text.isEmpty){
                                             // displayToast("Please Enter Came From");
                                            }else if(_selectedWardId2==null){
                                              displayToast("Please Select Purpose Of Visit");
                                            }else if(_selectedWhomToMeetValue==null){
                                              displayToast("Please Select Whom To Meet");
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
                              //SizedBox(height: 45),
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
    );
  }
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

