import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/advertisementPlaceRepo.dart';
import '../../services/advertisementPlaceTypeRepo.dart';
import '../../services/advertisementplanRepo.dart';
import '../../services/bookladvertisementRepo.dart';
import '../circle/circle.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class BookAdvertisement extends StatefulWidget {

  final complaintName;
  var bookAdvertisement;

  BookAdvertisement(this.bookAdvertisement, {super.key, this.complaintName});

  @override
  State<BookAdvertisement> createState() => _BookAdvertisementState();
}

class _BookAdvertisementState extends State<BookAdvertisement> {

  // Date PICKER
  DateTime selectedDate = DateTime.now();
  GeneralFunction generalFunction = GeneralFunction();
  final _formKey = GlobalKey<FormState>();
  String _toDate = 'To Date';
  String _fromDate = 'From Date';

  File? image;
  List distList = [];
  List stateList = [];
  List blockList = [];
  List marklocationList = [];
  List<dynamic> advertisementPlaceType = [];
  List<dynamic> advertisementPlace = [];
  List<dynamic> advertisementPlan = [];
  var _dropDownValueAdvertisementPlaceType;
  var _dropDownValueAdvertisementPlace;
  var _dropDownValueAdvertisementPlan;
  var _dropDownValueAdvertisementPlaceTypeValue;
  var _dropDownValueAdvertisementPlaceValue;
  var _dropDownValueAdvertisementPlanValue;

  // Focus
  FocusNode namefieldfocus = FocusNode();
  final distDropdownFocus = GlobalKey();

  // controller
  TextEditingController contentController = TextEditingController();
  TextEditingController contentDescriptionController = TextEditingController();

  // focus
  FocusNode contentfocus = FocusNode();
  FocusNode contentDescriptionfocus = FocusNode();

  //----- Api call Advertisement Place Type -----

  advertisementPlaceTypeApi() async {
    advertisementPlaceType = await AdvertiseMentPlaceTypeRepo().advertisementPlaceType();
    print(" -----xxxxx-  advertisementPlaceType--79---> $advertisementPlaceType");
    setState(() {});
  }
  // ---Api call Advertisement Place------
  advertisementPlaceApi(dropDownValueAdvertisementPlaceType) async {
    advertisementPlace = await AdvertiseMentPlaceRepo().advertisementPlace(dropDownValueAdvertisementPlaceType);
    print(" -----76---> $advertisementPlace");
    setState(() {});
  }
  // ------Api---call Advertisement Plan-----
  advertisementPlanApi(dropDownValueAdvertisementPlaceValue) async {
    advertisementPlan = await AdvertisementPlanRepo().advertisementPlan(dropDownValueAdvertisementPlaceValue);
    print(" -----xxxxx-  79-------> $advertisementPlan");
    setState(() {});
  }
  /// Todo bind Advertisement place Type

  Widget _bindAdvertisementPlaceType() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      height: 42, // Add height constraint
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            hint: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Select Advertisement Place Type",
                style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
              ),
            ),
            value: _dropDownValueAdvertisementPlaceTypeValue, // Ensure this is valid
            onChanged: (newValue) {
              setState(() {
                _dropDownValueAdvertisementPlaceTypeValue = newValue;
                // Find and update the corresponding ID
                final selectedItem = advertisementPlaceType.firstWhere(
                      (element) => element["sAdSpaceTypeName"] == newValue,
                  orElse: () => null,
                );
                if (selectedItem != null) {
                  _dropDownValueAdvertisementPlaceType = selectedItem['iAdSpaceTypeCode'];
                  print('-------$_dropDownValueAdvertisementPlaceType');
                  if(_dropDownValueAdvertisementPlaceType!=null && _dropDownValueAdvertisementPlaceType!='')
                  setState(() {
                    advertisementPlaceApi(_dropDownValueAdvertisementPlaceType);
                  });

                }
              });
            },
            items: advertisementPlaceType.map<DropdownMenuItem<String>>((dynamic item) {
              return DropdownMenuItem<String>(
                value: item["sAdSpaceTypeName"].toString(),
                child:  SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      item["sAdSpaceTypeName"].toString(),
                      overflow: TextOverflow.ellipsis, // Avoid text overflow
                      maxLines: 1,
                      style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
                    ),
                  ),
                )
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // bind Advertisement place
  Widget _bindAdvertisementPlace() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      height: 42, // Add height constraint
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            hint: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Select Advertisement Place",
                style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
              ),
            ),
            value: _dropDownValueAdvertisementPlace, // Ensure this is valid
            onChanged: (newValue) {
              setState(() {
                _dropDownValueAdvertisementPlace = newValue;
                // Find and update the corresponding ID
                final selectedItem = advertisementPlace.firstWhere(
                      (element) => element["sAdSpacePlace"] == newValue,
                  orElse: () => null,
                );
                if (selectedItem != null) {
                  _dropDownValueAdvertisementPlaceValue = selectedItem['iAdSpaceCode'];
                  print('----172-----$_dropDownValueAdvertisementPlaceValue');
                  if(_dropDownValueAdvertisementPlaceValue!=null && _dropDownValueAdvertisementPlaceValue!=""){
                    // call api
                    advertisementPlanApi(_dropDownValueAdvertisementPlaceValue);
                  }
                 //9871950881 advertisementPlaceApi(_dropDownValueAdvertisementPlace);
                }
              });
            },
            items: advertisementPlace.map<DropdownMenuItem<String>>((dynamic item) {
              return DropdownMenuItem<String>(
                  value: item["sAdSpacePlace"].toString(),
                  child:  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        item["sAdSpacePlace"].toString(),
                        overflow: TextOverflow.ellipsis, // Avoid text overflow
                        maxLines: 1,
                        style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
                      ),
                    ),
                  )
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  // bind Advertisement plan
  Widget _bindAdvertisementPlan() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      height: 42, // Add height constraint
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            hint: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Select Advertisement Plan",
                style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
              ),
            ),
            value: _dropDownValueAdvertisementPlan, // Ensure this is valid
            onChanged: (newValue) {
              setState(() {
                _dropDownValueAdvertisementPlan = newValue;
                // Find and update the corresponding ID
                final selectedItem = advertisementPlan.firstWhere(
                      (element) => element["sPlanName"] == newValue,
                  orElse: () => null,
                );
                if (selectedItem != null) {
                  _dropDownValueAdvertisementPlanValue = selectedItem['iPlanCode'];

                  print('----306-----$_dropDownValueAdvertisementPlanValue');
                  if(_dropDownValueAdvertisementPlanValue!=null && _dropDownValueAdvertisementPlanValue!=''){
                    setState(() {
                      // call api

                    });
                  }
                  //9871950881 advertisementPlaceApi(_dropDownValueAdvertisementPlace);
                }
              });
            },
            items: advertisementPlan.map<DropdownMenuItem<String>>((dynamic item) {
              return DropdownMenuItem<String>(
                  value: item["sPlanName"].toString(),
                  child:  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        item["sPlanName"].toString(),
                        overflow: TextOverflow.ellipsis, // Avoid text overflow
                        maxLines: 1,
                        style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
                      ),
                    ),
                  )
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print('-----27--${widget.bookAdvertisement}');
    super.initState();
    advertisementPlaceTypeApi();
    contentController = TextEditingController();
    contentDescriptionController = TextEditingController();
  }

  String generateRandom20DigitNumber() {
    final Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    return randomNumber;
  }
  // toast
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    contentController.dispose();
    contentDescriptionController.dispose();
    contentfocus.dispose();
    contentDescriptionfocus.dispose();
    super.dispose();
  }
  // submit button function
  void validateAndCallBookAdvertisementApi() async {
    // Validate form inputs
    final isFormValid = _formKey.currentState!.validate();

    // Get shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sPostedBy = prefs.getString('sContactNo');
    String sRequestNo = generateRandom20DigitNumber();

    // TextField inputs
    var contentTypeText = contentController.text.trim();

    // Validate all required fields
    if (!isFormValid) {
      print('--Form Validation Failed--');
      return;
    }

    if (_dropDownValueAdvertisementPlaceType == null) {
      displayToast('Select Advertisement Place Type');
      return;
    }

    if (contentTypeText.isEmpty) {
      displayToast('Please Enter Content Type');
      return;
    }

    if (_fromDate.isEmpty || _fromDate == "From Date") {
      displayToast('Please Select From Date');
      return;
    }

    if (_toDate.isEmpty || _toDate == "To Date") {
      displayToast('Please Select To Date');
      return;
    }

    if (sPostedBy == null) {
      displayToast('User not logged in. Please log in to proceed.');
      return;
    }

    // All validations passed; proceed to call API
    print('---Call API---');

    try {
      // Simulate API call here (Uncomment and replace with actual logic)
      var bookresponse = await BookAadvertisementRepo().bookadvertisement(
        context,
        sRequestNo,
        _dropDownValueAdvertisementPlaceType,
        _dropDownValueAdvertisementPlace,
        contentTypeText,
        _dropDownValueAdvertisementPlan,
        _fromDate,
        _toDate,
        sPostedBy,
      );

      // Example response handling (Modify based on your actual API response)
      var result = "${bookresponse['Result']}";
      var msg = "${bookresponse['Msg']}";
      //
      if (result == "1") {
        displayToast(msg);
        Navigator.pop(context);
      } else {
        displayToast(msg);
      }
     // displayToast("API Called Successfully"); // Temporary Success Message
    } catch (e) {
      print('Error calling API: $e');
      displayToast('Failed to book advertisement. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context, '${widget.bookAdvertisement}'),
      drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 10),
                child: SizedBox(
                  height: 120, // Height of the container
                  width: MediaQuery.of(context).size.width,
                  // width: 200, // Width of the container
                  //step3.jpg
                  child: Image.asset(
                    'assets/images/complaints_header.png',
                    // Replace 'image_name.png' with your asset image path
                    fit: BoxFit.fill, // Adjust the image fit to cover the container
                  ),
                ),
              ),
              // SizedBox(
              //   height: 120, // Height of the container
              //   width: MediaQuery.of(context).size.width,
              //   child: Image.asset(
              //     'assets/images/onlinecomplaint.jpeg',
              //     fit: BoxFit.cover, // Adjust the image fit to cover the container
              //   ),
              // ),
             // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 100, top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // Color of the shadow
                          spreadRadius: 5,
                          // Spread radius
                          blurRadius: 7,
                          // Blur radius
                          offset: Offset(0, 3), // Offset of the shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(left: 0, right: 10, top: 10),
                                child: Image.asset(
                                  'assets/images/ic_expense.png',
                                  // Replace with your image asset path
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Fill the below details',
                                    style: AppTextStyle
                                        .font16OpenSansRegularBlackTextStyle),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items vertically
                            children: <Widget>[
                              CircleWithSpacing(),
                              // Space between the circle and text
                              Text('Advertisement Place Type',style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _bindAdvertisementPlaceType(),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items vertically
                            children: <Widget>[
                              CircleWithSpacing(),
                              // Space between the circle and text
                              Text(
                                'Advertisement Place',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _bindAdvertisementPlace(),
                         // _bindAdvertisementPlaceType(),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items vertically
                            children: <Widget>[
                              CircleWithSpacing(),
                              // Space between the circle and text
                              Text('Advertisement Plan',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _bindAdvertisementPlan(),
                         // _bindAdvertisementPlaceType(),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items vertically
                            children: <Widget>[
                              CircleWithSpacing(),
                              // Space between the circle and text
                              Text(
                                'Content Type',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: Container(
                              height: 42,
                              color: Color(0xFFf2f3f5),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  focusNode: contentfocus,
                                  controller: contentController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    // labelText: AppStrings.txtMobile,
                                    // border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppPadding.p10),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return 'Enter location';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items vertically
                            children: <Widget>[
                              CircleWithSpacing(),
                              // Space between the circle and text
                              Text(
                                'Content Type Description',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: Container(
                              height: 42,
                              color: Color(0xFFf2f3f5),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  focusNode: contentDescriptionfocus,
                                  controller: contentDescriptionController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppPadding.p10),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          /// TODO pick date and as a ui TO Date and FromDATE
                          Container(
                            height: 80,
                            child: Row(
                              children: [
                                // First Container
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), // Set the current date as the initial date
                                        firstDate: DateTime.now(), // Prevent selection of past dates
                                        lastDate: DateTime(2101), // Set the maximum selectable date
                                      );
                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                        setState(() {
                                          _fromDate = formattedDate; // Update the selected date
                                        });
                                        print("-----803---$_fromDate");
                                      }
                                    },
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'assets/images/calendar.png'),
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _fromDate,
                                              style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Second Container
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), // Set the current date as the initial date
                                        firstDate: DateTime.now(), // Prevent selection of past dates
                                        lastDate: DateTime(2101), // Set the maximum selectable date
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                        setState(() {
                                          _toDate = formattedDate; // Update the selected date
                                        });
                                        print("----859--$_toDate");
                                      }
                                    },
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'assets/images/calendar.png'),
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _toDate,
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlackTextStyle,
                                              textAlign: TextAlign.center,
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
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: (){
                              validateAndCallBookAdvertisementApi();
                            },
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                // Make container fill the width of its parent
                                height: AppSize.s45,
                                padding: EdgeInsets.all(AppPadding.p5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF255898),
                                  // Background color using HEX value
                                  borderRadius: BorderRadius.circular(
                                      AppMargin.m10), // Rounded corners
                                ),
                                //  #00b3c7
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: AppTextStyle
                                        .font16OpenSansRegularWhiteTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
}
