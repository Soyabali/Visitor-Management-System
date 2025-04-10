import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/VisitorRegistrationRepo.dart';
import '../visitorLoginOtp/visitorLoginOtp.dart';

class VisitorLoginDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final FocusNode phoneFocus;
  final FocusNode nameFocus;

  const VisitorLoginDialog({
    Key? key,
    required this.formKey,
    required this.phoneController,
    required this.nameController,
    required this.phoneFocus,
    required this.nameFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginMap, result, msg;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        height: 285,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9EAFE),
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
                  "Visitor Login",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Form
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          // Mobile Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 75,
                              child: TextFormField(
                                focusNode: phoneFocus,
                                controller: phoneController,
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: "Mobile Number",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Color(0xFF255899),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Enter mobile number';
                                  if (value.length < 10)
                                    return 'Enter 10-digit mobile number';
                                  if (RegExp(r'[,#*]').hasMatch(value))
                                    return 'Invalid characters';
                                  return null;
                                },
                              ),
                            ),
                          ),

                          // Name Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 75,
                              child: TextFormField(
                                controller: nameController,
                                focusNode: nameFocus,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFF255899),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Enter Name';
                                  return null;
                                },
                              ),
                            ),
                          ),

                          // Send OTP Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () async {
                                final phone = phoneController.text.trim();
                                final name = nameController.text.trim();

                                if (formKey.currentState!.validate()) {
                                  print("Phone: $phone, Name: $name");
                                  // Call your login method here
                                  loginMap = await VisitorRegistrationRepo()
                                      .visitorRegistratiion(
                                        context,
                                        phone,
                                        name,
                                      );
                                  result = "${loginMap['Result']}";
                                  msg = "${loginMap['Msg']}";

                                  print("-----Login Result---->>>>--$loginMap");
                                  if (result == "1") {
                                    var sContactNo =
                                        loginMap["sContactNo"].toString();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('name', name);
                                    prefs.setString('sContactNo2', sContactNo);

                                    print("-----ContactNo Stored: $sContactNo");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VisitorLoginOtp(),
                                      ),
                                    );
                                  } else {
                                    displayToast(msg);
                                  }
                                } else {
                                  if (phone.isEmpty) {
                                    phoneFocus.requestFocus();
                                  } else if (name.isEmpty) {
                                    nameFocus.requestFocus();
                                  }
                                }
                              },
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0f6fb5),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(17),
                                    right: Radius.circular(17),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
