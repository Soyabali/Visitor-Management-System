import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/loader_helper.dart';
import '../../main.dart';
import '../../services/BindPurposeVisitVisitor.dart';
import '../../services/BindWhomToMeetVisitor.dart';
import '../../services/PostVisitorRepo2.dart';
import '../../services/SearchVisitorDetailsRepo.dart';
import '../../services/baseurl.dart';
import '../../services/vmsUpdateVisitorGsmid.dart';
import '../resources/app_text_style.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../visitorWating/visitorWatingScreen.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';

class VisitorEntryNew2 extends StatelessWidget {

  const VisitorEntryNew2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorEntryScreen2(),
    );
  }
}

class VisitorEntryScreen2 extends StatefulWidget {

  const VisitorEntryScreen2({super.key});

  @override
  State<VisitorEntryScreen2> createState() => _VisitorEntryScreenState();
}

class _VisitorEntryScreenState extends State<VisitorEntryScreen2> {
  final _formKey = GlobalKey<FormState>();

  List<dynamic> wardList = [];
  List<dynamic> whomToMeet = [];
  var abbbbb;
  var _dropDownWardValue;
  var _dropDownWhomToValue;
  var _selectedWardId2;
  var _selectedWhomToMeetValue;
  var result, msg, result2;
  File? image;
  var uplodedImage, token, sSubmitMessage, sProgressImg;
  var sContactNo, sVisitorName, sVisitorImage, iUserId;
  AudioPlayer player = AudioPlayer();

  // bind data on a DropDown
  bindPurposeWidget() async {
    wardList = await BindPurposeVisitVisitorRepo().getbindPurposeVisitVisitor();
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }
  // Whom To MEET
  whoomToWidget() async {
    whomToMeet = await BindWhomToMeetVisitorRepo().getbindWhomToMeetVisitor();
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
  bool _isTextEntered = false;

  late FocusNode nameControllerFocus,
      contactNoFocus,
      cameFromFocus,
      purposeOfVisitFocus,
      whomToMeetFocus,
      purposeFocus,
      approvalStatusFocus,
      idProofWithPhotoFocus,
      itemCarriedFocus;
  //late FocusNode contactNoFocus;

  Future pickImage() async {
    String? sToken = 'xyz';
    print('---Token----107--$sToken');
    // sVisitorImage=null;
    try {
      final pickFileid = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 65,
      );
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
      var request = http.MultipartRequest('POST', Uri.parse('$uploadImageApi'));
      request.headers['token'] = "840BCEF7-E02B-440D-8BDA-C1F1BF6A1C83";
      request.files.add(
        await http.MultipartFile.fromPath('sImagePath', imageFile.path),
      );
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      print("---------248-----$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        // sVisitorImage=null;
        setState(() {
          uplodedImage = responseData['Data'][0]['sImagePath'];
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

  getSearchVisitgorDetail() async {
    var repo = SearchVisitorDetailsRepo(); // Create an instance
    var searchVisitorDetail = await repo.searchVisitorDetail(context);
    setState(() {
      sContactNo = searchVisitorDetail['Data'][0]['sContactNo'].toString();
      sVisitorName = searchVisitorDetail['Data'][0]['sVisitorName'].toString();
      sVisitorImage =
          searchVisitorDetail['Data'][0]['sVisitorImage'].toString();
      // iUserId
      iUserId = searchVisitorDetail['Data'][0]['iUserId'].toString();
    });
    if (sVisitorImage != null) {
      uplodedImage = sVisitorImage;
    }
    // to set a value on a TextFormField Name
    if (sVisitorName != null && sVisitorName!.isNotEmpty) {
      _nameController.text = sVisitorName!;
    }
    // TextField Contact No.
    if (sContactNo != null && sContactNo!.isNotEmpty) {
      _ContactNoController.text = sContactNo!;
    }
  }

  // inputFormatter
  // String formatEachWord(String input) {
  //   return input
  //       .split(RegExp(r'(?<= )|(?<=_)')) // Keep space and underscore in split
  //       .map((word) {
  //     word = word.trim();
  //     if (word.isEmpty) return '';
  //     return word[0].toUpperCase() + word.substring(1).toLowerCase();
  //   })
  //   .join('');
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

  @override
  void initState() {
    // TODO: implement initState
    setupPushNotifications();
    bindPurposeWidget();
    whoomToWidget();
    generateRandom20DigitNumber();
    getSearchVisitgorDetail();
    _cameFromController.addListener(() {
      setState(() {
        _isTextEntered = _cameFromController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  // player start and stop code
  void playNotificationSound() async {
    await player.stop(); // Stop any previous sound
    await player.release(); // Release resources
    await player.setVolume(0.5);
    await player.play(
      AssetSource('sounds/coustom_sound.wav'),
      mode: PlayerMode.mediaPlayer,
    );

    // Automatically stop the sound after 2 seconds
    Future.delayed(Duration(seconds: 2), () async {
      await player.stop();
    });
  }

  Future<void> _stop() async {
    await player.stop(); // Force stop the sound
  }

  // firebase GetaToken
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(alert: true, badge: true, sound: true);
    token = await fcm.getToken();
    print("📌 Token: $token");
    // call Gsmid
    updateGsmid(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📦 Data Payload: ${message.data}");
      playNotificationSound();

      if (message.notification != null) {
        var title = message.notification!.title ?? "New Notification";
        var body = message.notification!.body ?? "You have received a new message";

        print("🔔 Foreground Notification Received: $title - $body");
        playNotificationSound();
        // Show notification dialog (User must click "OK" to proceed)
        _showNotificationDialog(title, body);
      }
    });
  }

  // GsmidVisitor
  updateGsmid(token) async {
    if (token != null) {
      var UpdateGsmid = await VmsUpdateVisitorgsmid().vmsUpdateVisitorGsmid(
        context,
        token,
      );
      print("-------Update Gsmid Visitor-------128-----$UpdateGsmid");
    } else {}
  }

  //
  // Show dialog with an "OK" button to navigate
  void _showNotificationDialog(String title, String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // Prevents user from closing manually
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded Dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.purpleAccent,
                ], // Attractive gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Icon
                Icon(Icons.notifications_active, size: 50, color: Colors.white),
                SizedBox(height: 10),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 15),
                // Custom Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                    backgroundColor:
                        Colors.amberAccent, // Attractive button color
                    elevation: 5,
                  ),
                  onPressed: () {
                    _stop(); // Stop sound
                    // call api
                    //  getLocatDataBase();
                    Navigator.pop(context); // Close Dialog
                    // hide the enter into the new Screen
                    _navigateToVisitorList(
                      title,
                      message,
                    ); // Navigate to new screen
                  },
                  child: Text(
                    "Ok",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  // notification navigate
  void _navigateToVisitorList(String? title, String? body) async {
    if (navigatorKey.currentContext != null) {
      if (title == "Request Posted") {
        print("-------382-------xxxxxxx---$title");

        Navigator.pushReplacement(
          navigatorKey.currentContext!, // Use navigatorKey consistently
          MaterialPageRoute(
            builder:
                (context) =>
                    VisitorWatingScreenPage(sSubmitMessage, sProgressImg),
          ),
        );
      } else {
        print("-------384-------xxxxxx---$title");

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => VisitorLoginEntry()),
        );
      }
    }
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

  void _incrementVisitorCount() {
    setState(() {
      if (_visitorCount < 10) {
        // Allow only if less than 10
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
                    print(
                      "----whom To meet --149--xx-->>>..xxx.---$_selectedWhomToMeetValue",
                    );
                  });
                },
                items:
                    whomToMeet.map((dynamic item) {
                      return DropdownMenuItem(
                        value: item["sUserName"].toString(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['sUserName'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
                                style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg.png',
                    ), // Path to your image
                    fit: BoxFit.cover, // Make it cover the whole screen
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const VisitorLoginEntry(),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 50, // Set proper width
                              height: 50, // Set proper height
                              child: Image.asset("assets/images/backtop.png"),
                            ),
                          ),
                          SizedBox(width: 4),
                          // Positioned(
                          //   top: 65,
                          //   left: 10,
                          //   child: Center(
                          //     child: Container(
                          //       height: 32,
                          //       //width: 140,
                          //       child: Image.asset(
                          //         'assets/images/synergylogo.png', // Replace with your image path
                          //         // Set height
                          //         fit: BoxFit.cover, // Ensures the image fills the given size
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   height: 32,
                          //   //width: 140,
                          //   child: Image.asset(
                          //     'assets/images/synergylogo.png', // Replace with your image path
                          //     // Set height
                          //     fit: BoxFit
                          //             .cover, // Ensures the image fills the given size
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // form Widget
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              print("-----Pick images----");
                              await pickImage();
                              setState(
                                () {},
                              ); // Ensure the UI updates when the image changes
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child:
                                  (uplodedImage == null ||
                                          uplodedImage!.isEmpty)
                                      ? Image.asset(
                                        'assets/images/human.png',
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.network(
                                        uplodedImage!,
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/images/human.png',
                                            height: 140,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                            ),
                          ),
                          SizedBox(height: 5),
                          const Center(
                            child: Text(
                              'Click image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          Center(
                            // This ensures GlassmorphicContainer is centered properly
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 10,
                              ),
                              child: GlassmorphicContainer(
                                height: 470,
                                width:
                                    MediaQuery.of(context).size.width > 600
                                        ? MediaQuery.of(context).size.width *
                                            0.6 // 60% width for tablets
                                        : MediaQuery.of(
                                          context,
                                        ).size.width, // Full width for mobile
                                borderRadius: 20,
                                blur: 10,
                                alignment: Alignment.center,
                                border: 1,
                                linearGradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.6),
                                    Colors.white.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderGradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.6),
                                    Colors.white24.withOpacity(0.5),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFC9EAFE),
                                          borderRadius: BorderRadius.circular(17),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              spreadRadius: 2,
                                              offset: Offset(2, 4),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Visitor Entry",
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      // Your remaining form fields...
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // TextFormField
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors
                                                        .white, // Set the background color to white
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        4.0,
                                                      ),
                                                      bottomLeft:
                                                          Radius.circular(4.0),
                                                    ),
                                              ),
                                              child: TextFormField(
                                                controller: _nameController,
                                                readOnly: true,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ), // Set text color
                                                decoration: const InputDecoration(
                                                  // Removed labelText and labelStyle
                                                  hintText:
                                                      'Enter Contact No', // Optional: Keep or remove
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  border:
                                                      InputBorder
                                                          .none, // No border
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors
                                                      .white, // Set the background color to white
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(4.0),
                                                    bottomLeft: Radius.circular(4.0,
                                                    ),
                                                  ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              '$_visitorCount',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          // 3. SizedBox (for Spacing)
                                          const SizedBox(width: 2.0),
                                          // 4. Increment IconButton
                                          IconButton(
                                            onPressed: _incrementVisitorCount,
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            ),
                                          ),
                                          // 5. Decrement IconButton
                                          IconButton(
                                            onPressed: _decrementVisitorCount,
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                          ),
                                          // 2. Text with Matching Border
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      // contact Number Fields
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Colors
                                                  .white, // Set the background color to white
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            bottomLeft: Radius.circular(4.0),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _ContactNoController,
                                          readOnly: true,
                                          keyboardType:
                                              TextInputType
                                                  .phone, // Set keyboard type to phone
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                          decoration: const InputDecoration(
                                            // Removed labelText and labelStyle
                                            hintText:
                                                'Enter Contact No', // Optional hint text
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                            border:
                                                InputBorder.none, // No border
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                ),
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      //  CameFrom Visit TextField
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors
                                                      .white, // Set the background color to white
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      4.0,
                                                    ),
                                                    bottomLeft: Radius.circular(
                                                      4.0,
                                                    ),
                                                  ),
                                            ),
                                            child: TextFormField(
                                              controller: _cameFromController,
                                              autofocus: true,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(50), // increased limit for full address
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(r"[a-zA-Z0-9\s,.\-#/]+"),
                                                ),
                                              ],
                                              style: const TextStyle(color: Colors.black),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
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
                                          if (!_isTextEntered)
                                            Positioned(
                                              left: 12,
                                              top: 12,
                                              child: RichText(
                                                text: const TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  children: [
                                                    TextSpan(text: 'From '),
                                                    TextSpan(
                                                      text: '*',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      _purposeBindData(),
                                      SizedBox(height: 10),
                                      // Whom of Visit
                                      _WhomToMeet(),
                                      // SizedBox(height: 5),
                                      SizedBox(height: 14),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () async {
                                            //  iEntryBy
                                            String iVisitorId = generateRandom20DigitNumber();

                                            var visitorName =
                                                _nameController.text.trim();
                                            //   _visitorCount
                                            var contactNo =
                                                _ContactNoController.text
                                                    .trim();
                                            var cameFrom =
                                                _cameFromController.text.trim();
                                            var purposeOfVisit =
                                                _purposeOfVisitController.text
                                                    .trim();
                                            //   _selectedWhomToMeetValue
                                            //  _selectedWardId2

                                            if (_formKey.currentState!
                                                    .validate() &&
                                                visitorName.isNotEmpty &&
                                                _visitorCount != null &&
                                                contactNo.isNotEmpty &&
                                                cameFrom.isNotEmpty &&
                                                _selectedWardId2 != null &&
                                                _selectedWhomToMeetValue !=
                                                    null &&
                                                uplodedImage != null &&
                                                sVisitorImage != null) {
                                              var postComplaintResponse =
                                                  await PostVisitorRepo2()
                                                      .postComplaint(
                                                        context,
                                                        visitorName,
                                                        _visitorCount,
                                                        contactNo,
                                                        cameFrom,
                                                        _selectedWhomToMeetValue,
                                                        _selectedWardId2,
                                                        iVisitorId,
                                                        uplodedImage,
                                                        iUserId,
                                                      );

                                              print(
                                                '----502--->>>>>---$postComplaintResponse',
                                              );
                                              result =
                                                  postComplaintResponse['Result'];
                                              msg =
                                                  postComplaintResponse['Msg'];

                                              sSubmitMessage =
                                                  postComplaintResponse['sSubmitMessage'];
                                              sProgressImg =
                                                  postComplaintResponse['sProgressImg'];
                                              setState(() {});
                                            } else {
                                              if (_nameController
                                                  .text
                                                  .isEmpty) {
                                                // phoneNumberfocus.requestFocus();
                                                displayToast(
                                                  "Please Enter Visitor Name",
                                                );
                                              } else if (_ContactNoController
                                                  .text
                                                  .isEmpty) {
                                                // passWordfocus.requestFocus();
                                                displayToast(
                                                  "Please Enter Contact No",
                                                );
                                              } else if (_cameFromController
                                                  .text
                                                  .isEmpty) {
                                                // displayToast("Please Enter Came From");
                                              } else if (_selectedWardId2 ==
                                                  null) {
                                                displayToast(
                                                  "Please Select Purpose",
                                                );
                                              } else if (_selectedWhomToMeetValue ==
                                                  null) {
                                                displayToast(
                                                  "Please Select Whom to meet",
                                                );
                                              } else if (uplodedImage == null) {
                                                displayToast(
                                                  "Please Select Images",
                                                );
                                              } else if (sVisitorImage ==
                                                  null) {
                                                displayToast(
                                                  "Please Select Images",
                                                );
                                              }
                                            }

                                            /// Please Select Whom To Meet  //  Please Select Purpose
                                            if (result == "1") {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          VisitorWatingScreenPage(
                                                            sSubmitMessage,
                                                            sProgressImg,
                                                          ),
                                                ),
                                              );
                                              // );
                                            } else {
                                              // show toast
                                              displayToast(msg);
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: double.infinity, // Full width
                                            decoration: const BoxDecoration(
                                              color: Color(
                                                0xFF0f6fb5,
                                              ), // Blue color
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                    left: Radius.circular(
                                                      17,
                                                    ), // Left radius
                                                    right: Radius.circular(
                                                      17,
                                                    ), // Right radius
                                                  ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Send Request',
                                                style: TextStyle(
                                                  color: Colors.white, // Text color
                                                  fontSize: 16, // Text size
                                                  fontWeight:
                                                   FontWeight
                                                          .bold, // Text weight
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // fullPage backgroundImage
              // Positioned(
              //   top: 0, // Start from the top
              //   left: 0,
              //   right: 0,
              //   height:
              //       MediaQuery.of(context).size.height *
              //       0.7, // 70% of screen height
              //   child: Image.asset(
              //     'assets/images/bg.png', // Replace with your image path
              //     fit: BoxFit.cover, // Covers the area properly
              //   ),
              // ),
              // // backbutton
              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const VisitorLoginEntry(),
              //         ),
              //       );
              //     },
              //     child: SizedBox(
              //       width: 50, // Set proper width
              //       height: 50, // Set proper height
              //       child: Image.asset("assets/images/backtop.png"),
              //     ),
              //   ),
              // ),
              // // logo on a top
              // Positioned(
              //   top: 85,
              //   left: 95,
              //   child: Center(
              //     child: Container(
              //       height: 32,
              //       //width: 140,
              //       child: Image.asset(
              //         'assets/images/Synergywhitelogo.png', // Replace with your image path
              //         // Set height
              //         fit: BoxFit.cover, // Ensures the image fills the given size
              //       ),
              //     ),
              //   ),
              // ),
              // mainForm in this Card and multiple other widget
              // Positioned(
              //   top: 140,
              //   left: 0,
              //   right: 0,
              //   child: Align(
              //     alignment: Alignment.topCenter,
              //     child: Form(
              //       key: _formKey,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           InkWell(
              //             onTap: () async {
              //               print("-----Pick images----");
              //               await pickImage();
              //               setState(
              //                 () {},
              //               ); // Ensure the UI updates when the image changes
              //             },
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(75),
              //               child:
              //                   (uplodedImage == null || uplodedImage!.isEmpty)
              //                       ? Image.asset(
              //                         'assets/images/human.png',
              //                         height: 150,
              //                         width: 150,
              //                         fit: BoxFit.cover,
              //                       )
              //                       : Image.network(
              //                         uplodedImage!,
              //                         height: 150,
              //                         width: 150,
              //                         fit: BoxFit.cover,
              //                         loadingBuilder: (
              //                           context,
              //                           child,
              //                           loadingProgress,
              //                         ) {
              //                           if (loadingProgress == null) return child;
              //                           return Center(
              //                             child: CircularProgressIndicator(),
              //                           );
              //                         },
              //                         errorBuilder: (context, error, stackTrace) {
              //                           return Image.asset(
              //                             'assets/images/human.png',
              //                             height: 150,
              //                             width: 150,
              //                             fit: BoxFit.cover,
              //                           );
              //                         },
              //                       ),
              //             ),
              //           ),
              //           SizedBox(height: 10),
              //           const Center(
              //             child: Text(
              //               'Click image',
              //               style: TextStyle(color: Colors.white, fontSize: 14),
              //             ),
              //           ),
              //           SizedBox(height: 50),
              //
              //           Center(
              //             // This ensures GlassmorphicContainer is centered properly
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
              //               child: GlassmorphicContainer(
              //                 height: 470,
              //                 width:
              //                     MediaQuery.of(context).size.width > 600
              //                         ? MediaQuery.of(context).size.width * 0.6 // 60% width for tablets
              //                         : MediaQuery.of(context,).size.width, // Full width for mobile
              //                 borderRadius: 20,
              //                 blur: 10,
              //                 alignment: Alignment.center,
              //                 border: 1,
              //                 linearGradient: LinearGradient(
              //                   colors: [
              //                     Colors.white.withOpacity(0.6),
              //                     Colors.white.withOpacity(0.5),
              //                   ],
              //                   begin: Alignment.topLeft,
              //                   end: Alignment.bottomRight,
              //                 ),
              //                 borderGradient: LinearGradient(
              //                   colors: [
              //                     Colors.white.withOpacity(0.6),
              //                     Colors.white24.withOpacity(0.5),
              //                   ],
              //                 ),
              //                 child: Padding(
              //                   padding: const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Column(
              //                     children: [
              //                       SizedBox(height: 10),
              //                       Container(
              //                         height: 35,
              //                         decoration: BoxDecoration(
              //                           color: Color(0xFFC9EAFE),
              //                           borderRadius: BorderRadius.circular(17),
              //                           boxShadow: const [
              //                             BoxShadow(
              //                               color: Colors.black26,
              //                               blurRadius: 3,
              //                               spreadRadius: 2,
              //                               offset: Offset(2, 4),
              //                             ),
              //                           ],
              //                         ),
              //                         alignment: Alignment.center,
              //                         child: const Text(
              //                           "Visitor Entry",
              //                           style: TextStyle(
              //                             color: Colors.black45,
              //                             fontSize: 16,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ),
              //                       SizedBox(height: 10),
              //                       // Your remaining form fields...
              //                       Row(
              //                         mainAxisAlignment: MainAxisAlignment.start,
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           // TextFormField
              //                           Expanded(
              //                             child: Container(
              //                               decoration: BoxDecoration(
              //                                 color:
              //                                     Colors
              //                                         .white, // Set the background color to white
              //                                 border: Border.all(
              //                                   color: Colors.grey,
              //                                 ),
              //                                 borderRadius: const BorderRadius.only(
              //                                   topLeft: Radius.circular(4.0),
              //                                   bottomLeft: Radius.circular(4.0),
              //                                 ),
              //                               ),
              //                               child: TextFormField(
              //                                 controller: _nameController,
              //                                 readOnly: true,
              //                                 style: const TextStyle(
              //                                   color: Colors.black,
              //                                 ), // Set text color
              //                                 decoration: const InputDecoration(
              //                                   // Removed labelText and labelStyle
              //                                   hintText:
              //                                       'Enter Contact No', // Optional: Keep or remove
              //                                   hintStyle: TextStyle(
              //                                     color: Colors.black,
              //                                   ),
              //                                   border:
              //                                       InputBorder.none, // No border
              //                                   contentPadding:
              //                                       EdgeInsets.symmetric(
              //                                         horizontal: 12.0,
              //                                       ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           SizedBox(width: 2),
              //                           Container(
              //                             height: 50,
              //                             decoration: BoxDecoration(
              //                               color:
              //                                   Colors
              //                                       .white, // Set the background color to white
              //                               border: Border.all(color: Colors.grey),
              //                               borderRadius: const BorderRadius.only(
              //                                 topLeft: Radius.circular(4.0),
              //                                 bottomLeft: Radius.circular(4.0),
              //                               ),
              //                             ),
              //                             padding: const EdgeInsets.symmetric(
              //                               horizontal: 16.0,
              //                               vertical: 10,
              //                             ),
              //                             child: Text(
              //                               '$_visitorCount',
              //                               style: TextStyle(fontSize: 16),
              //                             ),
              //                           ),
              //                           // 3. SizedBox (for Spacing)
              //                           const SizedBox(width: 2.0),
              //                           // 4. Increment IconButton
              //                           IconButton(
              //                             onPressed: _incrementVisitorCount,
              //                             icon: const Icon(
              //                               Icons.add,
              //                               color: Colors.green,
              //                             ),
              //                           ),
              //                           // 5. Decrement IconButton
              //                           IconButton(
              //                             onPressed: _decrementVisitorCount,
              //                             icon: const Icon(
              //                               Icons.remove,
              //                               color: Colors.red,
              //                             ),
              //                           ),
              //                           // 2. Text with Matching Border
              //                         ],
              //                       ),
              //                       SizedBox(height: 10),
              //                       // contact Number Fields
              //                       Container(
              //                         decoration: BoxDecoration(
              //                           color: Colors.white, // Set the background color to white
              //                           border: Border.all(color: Colors.grey),
              //                           borderRadius: const BorderRadius.only(
              //                             topLeft: Radius.circular(4.0),
              //                             bottomLeft: Radius.circular(4.0),
              //                           ),
              //                         ),
              //                         child: TextFormField(
              //                           controller: _ContactNoController,
              //                           readOnly: true,
              //                           keyboardType: TextInputType.phone, // Set keyboard type to phone
              //                           style: const TextStyle(color: Colors.black),
              //                           inputFormatters: [
              //                             LengthLimitingTextInputFormatter(10),
              //                           ],
              //                           decoration: const InputDecoration(
              //                             // Removed labelText and labelStyle
              //                             hintText: 'Enter Contact No', // Optional hint text
              //                             hintStyle: TextStyle(color: Colors.black),
              //                             border: InputBorder.none, // No border
              //                             contentPadding: EdgeInsets.symmetric(
              //                               horizontal: 12.0,
              //                             ),
              //                           ),
              //                           autovalidateMode: AutovalidateMode.onUserInteraction,
              //                         ),
              //                       ),
              //                       SizedBox(height: 10),
              //                       //  CameFrom Visit TextField
              //                       Stack(
              //                         children: [
              //                           Container(
              //                             decoration: BoxDecoration(
              //                               color: Colors.white, // Set the background color to white
              //                               border: Border.all(color: Colors.grey),
              //                               borderRadius: const BorderRadius.only(
              //                                 topLeft: Radius.circular(4.0),
              //                                 bottomLeft: Radius.circular(4.0),
              //                               ),
              //                             ),
              //                             child: TextFormField(
              //                               controller: _cameFromController,
              //                               autofocus: true,
              //                               style: const TextStyle(
              //                                 color: Colors.black,
              //                               ),
              //                               decoration: const InputDecoration(
              //                                 border: InputBorder.none,
              //                                 contentPadding: EdgeInsets.symmetric(
              //                                   horizontal: 12.0,
              //                                 ),
              //                               ),
              //                               autovalidateMode:
              //                                   AutovalidateMode.onUserInteraction,
              //                               validator: (value) {
              //                                 if (value == null ||
              //                                     value.trim().isEmpty) {
              //                                   return 'From is required';
              //                                 }
              //                                 return null;
              //                               },
              //                             ),
              //                           ),
              //                           if (!_isTextEntered)
              //                             Positioned(
              //                               left: 12,
              //                               top: 12,
              //                               child: RichText(
              //                                 text: const TextSpan(
              //                                   style: TextStyle(
              //                                     fontSize: 16,
              //                                     color: Colors.black,
              //                                   ),
              //                                   children: [
              //                                     TextSpan(text: 'From '),
              //                                     TextSpan(
              //                                       text: '*',
              //                                       style: TextStyle(
              //                                         color: Colors.red,
              //                                         fontWeight: FontWeight.bold,
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                         ],
              //                       ),
              //                       SizedBox(height: 10),
              //                       _purposeBindData(),
              //                       SizedBox(height: 10),
              //                       // Whom of Visit
              //                       _WhomToMeet(),
              //                       // SizedBox(height: 5),
              //                       SizedBox(height: 15),
              //                       Container(
              //                         child: GestureDetector(
              //                           onTap: () async {
              //                             //  iEntryBy
              //                             String iVisitorId = generateRandom20DigitNumber();
              //
              //                             var visitorName =
              //                                 _nameController.text.trim();
              //                             //   _visitorCount
              //                             var contactNo =
              //                                 _ContactNoController.text.trim();
              //                             var cameFrom =
              //                                 _cameFromController.text.trim();
              //                             var purposeOfVisit =
              //                                 _purposeOfVisitController.text.trim();
              //                             //   _selectedWhomToMeetValue
              //                             //  _selectedWardId2
              //
              //                             if (_formKey.currentState!.validate() &&
              //                                 visitorName.isNotEmpty &&
              //                                 _visitorCount != null &&
              //                                 contactNo.isNotEmpty &&
              //                                 cameFrom.isNotEmpty &&
              //                                 _selectedWardId2 != null &&
              //                                 _selectedWhomToMeetValue != null &&
              //                                 uplodedImage != null &&
              //                                 sVisitorImage != null) {
              //
              //                               var postComplaintResponse =
              //                                   await PostVisitorRepo2()
              //                                       .postComplaint(
              //                                         context,
              //                                         visitorName,
              //                                         _visitorCount,
              //                                         contactNo,
              //                                         cameFrom,
              //                                         _selectedWhomToMeetValue,
              //                                         _selectedWardId2,
              //                                         iVisitorId,
              //                                         uplodedImage,
              //                                         iUserId,
              //                                       );
              //
              //                               print('----502--->>>>>---$postComplaintResponse');
              //                               result = postComplaintResponse['Result'];
              //                               msg = postComplaintResponse['Msg'];
              //
              //                                sSubmitMessage = postComplaintResponse['sSubmitMessage'];
              //                                sProgressImg = postComplaintResponse['sProgressImg'];
              //                                setState(() {
              //
              //                                });
              //
              //                             } else {
              //                               if (_nameController.text.isEmpty) {
              //                                 // phoneNumberfocus.requestFocus();
              //                                 displayToast(
              //                                   "Please Enter Visitor Name",
              //                                 );
              //                               } else if (_ContactNoController
              //                                   .text
              //                                   .isEmpty) {
              //                                 // passWordfocus.requestFocus();
              //                                 displayToast(
              //                                   "Please Enter Contact No",
              //                                 );
              //                               } else if (_cameFromController
              //                                   .text
              //                                   .isEmpty) {
              //                                 // displayToast("Please Enter Came From");
              //                               } else if (_selectedWardId2 == null) {
              //                                 displayToast("Please Select Purpose");
              //                               } else if (_selectedWhomToMeetValue ==
              //                                   null) {
              //                                 displayToast(
              //                                   "Please Select Whom to meet",
              //                                 );
              //                               } else if (uplodedImage == null) {
              //                                 displayToast("Please Select Images");
              //                               } else if (sVisitorImage == null) {
              //                                 displayToast("Please Select Images");
              //                               }
              //                             }
              //
              //                             /// Please Select Whom To Meet  //  Please Select Purpose
              //                             if (result == "1") {
              //
              //                               Navigator.pushReplacement(
              //                                 context,
              //                                 MaterialPageRoute(
              //                                   builder:
              //                                       (context) =>
              //                                           VisitorWatingScreenPage(sSubmitMessage,sProgressImg),
              //                                 ),
              //                               );
              //                               // );
              //                             } else {
              //                               // show toast
              //                               displayToast(msg);
              //                             }
              //                           },
              //                           child: Container(
              //                             height: 45,
              //                             width: double.infinity, // Full width
              //                             decoration: const BoxDecoration(
              //                               color: Color(0xFF0f6fb5), // Blue color
              //                               borderRadius: BorderRadius.horizontal(
              //                                 left: Radius.circular(17), // Left radius
              //                                 right: Radius.circular(
              //                                   17,
              //                                 ), // Right radius
              //                               ),
              //                             ),
              //                             child: const Center(
              //                               child: Text(
              //                                 'Send Request',
              //                                 style: TextStyle(
              //                                   color: Colors.white, // Text color
              //                                   fontSize: 16, // Text size
              //                                   fontWeight:
              //                                       FontWeight.bold, // Text weight
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // company logo set a bottom
              Positioned(
                bottom: 10, // 10 pixels above the bottom
                left: 0,
                right: 0,
                child: Center(
                  // Ensures the logo is centered horizontally
                  child: Image.asset(
                    'assets/images/companylogo2.png',
                    fit: BoxFit.contain, // Ensures the full image is visible
                    height: 50, // Fixed height
                    width: 150, // Set width if needed (optional)
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
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
