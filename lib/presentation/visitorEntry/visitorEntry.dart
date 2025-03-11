import 'package:flutter/material.dart';
import '../../services/bindCityzenWardRepo.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class VisitorEntry extends StatelessWidget {
  const VisitorEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  List<dynamic> wardList = [];
  var _dropDownWardValue;
  var _selectedWardId2;

  // bind data on a DropDown
  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard();
    print(" -----xxxxx-  wardList--50---> $wardList");
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
                value: _dropDownWardValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWardValue = newValue;
                    wardList.forEach((element) {
                      if (element["sSectorName"] == _dropDownWardValue) {
                        _selectedWardId2 = element['iSectorCode'];

                      }
                    });
                    print("----wardCode---$_selectedWardId2");
                  });
                },
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sSectorName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sSectorName'].toString(),
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
                    text: "Purpose",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWardValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWardValue = newValue;
                    wardList.forEach((element) {
                      if (element["sSectorName"] == _dropDownWardValue) {
                        _selectedWardId2 = element['iSectorCode'];

                      }
                    });
                    print("----wardCode---$_selectedWardId2");
                  });
                },
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sSectorName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sSectorName'].toString(),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Visitor Entry',style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal
                        ),),
                        // Text('Entry',style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.normal
                        // ),),
                        SizedBox(height: 35),
                        Container(
                          child: Image.asset('assets/images/human.png',
                           height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //  Visitor Name Fields
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
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
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Set the background color to white
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
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
                                icon: const Icon(Icons.add,color: Colors.red,),
                              ),
                              // 5. Decrement IconButton
                              IconButton(
                                onPressed: _decrementVisitorCount,
                                icon: const Icon(Icons.remove,color: Colors.white,),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        // contact Number Fields
                        Container(
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
                            decoration: const InputDecoration(
                              labelText: 'Contact No',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return 'Enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        //  CameFrom Visit TextField
                        Container(
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
                        SizedBox(height: 5),
                        // Purpose Of Visit TextFields
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the background color to white
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                            ),
                          ),
                          child: TextFormField(
                            controller: _purposeOfVisitController,
                            style: const TextStyle(color: Colors.black), // Set the text color to black
                            decoration: const InputDecoration(
                              labelText: 'Purpose Of Visit',
                              labelStyle: TextStyle(color: Colors.black),
                              // hintText: 'Enter Contact No',
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // Whom of Visit
                        _WhomToMeet(),
                        SizedBox(height: 5),
                        _purposeBindData(),
                        SizedBox(height: 85),
                        Container(
                          child:  GestureDetector(
                            onTap: (){
                              print('----submit--');
                            },
                            child: Image.asset('assets/images/submit.png', // Replace with your image path
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
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

