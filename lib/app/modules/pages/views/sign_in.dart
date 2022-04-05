import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/services/auth.dart';
import 'package:heatlth_monitor/app/widgets/custom_elevated_button.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatelessWidget {
  final AuthBase auth;
  LoginPage({Key? key, required this.auth}) : super(key: key);
  RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(kBackgroundPng),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 350.h, left: 50),
                child: MediumText(text: "Welcome!", textColor: kMainColor),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: LargeText(text: "Sign In!", textColor: kMainColor),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: SmallText(
                    text: "Hi there! Nice to see you again.",
                    textColor: kBlack),
              ),
              SizedBox(height: 130.h),
              CustomElevatedButton(
                  controller: googleController,
                  icon: kGoogleSvg,
                  text: "Google",
                  ontap: () {
                    try {
                      auth.signInWithGoogle(googleController);
                    } on FirebaseAuthException catch (e) {
                      googleController.error();
                      Get.snackbar("Error", e.message.toString());
                      2
                          .seconds
                          .delay()
                          .then((value) => googleController.reset());
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }
}
