import 'package:flutter/cupertino.dart';
import 'package:puri/app/myapp.dart';
import 'package:puri/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:puri/presentation/resources/app_strings.dart';

import 'app_text_style.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoInternetState();
  }
}

class NoInternetState extends State<NoInternet> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 4), () {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, AppStrings.routeToLogin, (route) => false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppColors.backgroundColor,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset("assets/icon/icon.png",
                fit: BoxFit.cover,
                // color: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text("No Internet Connection",
                  // AppStrings.txtCopyright,
                  style: AppTextStyle.font14OpenSansBoldBlackTextStyle),
            ),
            MaterialButton(
                color: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => MyApp())));
                },
                child: Text("Retry",
                    style: AppTextStyle.font14OpenSansSemiBoldGreenTextStyle))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.orange, AppColors.lightGreen],
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text('Visitor Management System',
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}