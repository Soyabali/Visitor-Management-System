import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/VisitorRegistrationRepo.dart';
import '../visitorLoginOtp/visitorLoginOtp.dart';

class VisitorLoginDialog extends StatefulWidget {
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
  State<VisitorLoginDialog> createState() => _VisitorLoginDialogState();
}

class _VisitorLoginDialogState extends State<VisitorLoginDialog> {
  String? phoneError;
  String? nameError;

  // validator function
  String? validateName(String value) {
    if (value.isEmpty) return 'Enter Name';

    if (value.length > 30) return 'Name must be at most 30 characters';

    if (!RegExp(r'^[a-zA-Z_ ]+$').hasMatch(value)) {
      return 'Only letters, spaces, and underscores are allowed';
    }

    if (!RegExp(r'^[A-Z]').hasMatch(value)) {
      return 'First character must be uppercase';
    }

    for (int i = 1; i < value.length; i++) {
      if ((value[i - 1] == ' ' || value[i - 1] == '_') && !RegExp(r'[A-Z]').hasMatch(value[i])) {
        return 'Each word must start with a capital letter';
      }

      if (i > 1 && value[i - 1] != ' ' && value[i - 1] != '_' && RegExp(r'[A-Z]').hasMatch(value[i])) {
        return 'Only the first letter of each word should be capital';
      }
    }

    return null;
  }
  // autoformat name
  String autoFormatName(String input) {
    return input
        .split(RegExp(r'[_ ]'))
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ')
        .replaceAllMapped(RegExp(r' +'), (match) => ' '); // clean multiple spaces
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
  Widget build(BuildContext context) {
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
                    key: widget.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          // Mobile Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 80,
                              child: TextFormField(
                                focusNode: widget.phoneFocus,
                                controller: widget.phoneController,
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: "Mobile Number",
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Color(0xFF255899),
                                  ),
                                  errorText: phoneError,
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
                          ),
                          // Name Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 80,
                              child: TextFormField(
                                controller: widget.nameController,
                                focusNode: widget.nameFocus,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_ ]')),
                                ],
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person, color: Color(0xFF255899)),
                                  errorText: nameError,
                                ),
                                onChanged: (value) {
                                  final formatted = autoFormatName(value);
                                  // Update the controller only if formatted text is different
                                  if (value != formatted) {
                                    final cursorPosition = formatted.length;
                                    widget.nameController.value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(offset: cursorPosition),
                                    );
                                  }
                                  setState(() {
                                    final error = validateName(formatted);
                                    nameError = error == null || error.isEmpty ? null : error;
                                  });
                                },
                              ),
                            ),
                          ),

                          // Send OTP Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () async {
                                final phone = widget.phoneController.text.trim();
                                final name = widget.nameController.text.trim();

                                if (widget.formKey.currentState!.validate()) {
                                  var loginMap = await VisitorRegistrationRepo().visitorRegistratiion(
                                    context,
                                    phone,
                                    name,
                                  );
                                  var result = "${loginMap['Result']}";
                                  var msg = "${loginMap['Msg']}";

                                  if (result == "1") {
                                    var sContactNo = loginMap["sContactNo"].toString();
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('name', name);
                                    prefs.setString('sContactNo2', sContactNo);

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
                                    widget.phoneFocus.requestFocus();
                                  } else if (name.isEmpty) {
                                    widget.nameFocus.requestFocus();
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

