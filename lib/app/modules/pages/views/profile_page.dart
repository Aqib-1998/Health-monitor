import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/typography.dart';
import 'package:heatlth_monitor/app/modules/models/usermodel.dart';
import 'package:heatlth_monitor/app/modules/pages/views/auth_view.dart';
import 'package:heatlth_monitor/app/widgets/custom_elevated_button.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../services/auth.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final AuthBase auth;
  const ProfilePage({Key? key, required this.uid, required this.auth})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

RoundedLoadingButtonController controller = RoundedLoadingButtonController();

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: kMainColor,
            );
          }
          var currentUser =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return SizedBox(
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LargeText(text: "Profile", textColor: kMainColor),
                SizedBox(
                  height: 100.h,
                ),
                CircleAvatar(
                  radius: 80.r,
                  backgroundColor: kWhiteColor,
                  backgroundImage: NetworkImage(currentUser.profilePhoto),
                ),
                SizedBox(
                  height: 10.h,
                ),
                LargeText(text: currentUser.username, textColor: kMainColor),
                SizedBox(
                  height: 10.h,
                ),
                SmallText(text: currentUser.email, textColor: kMainColor),
                Spacer(),
                Padding(
                  padding: kAppCornerPadding,
                  child: CustomElevatedButton(
                      icon: kSignoutSvg,
                      text: "Logout",
                      ontap: () => Get.defaultDialog(
                          cancel: TextButton(
                              onPressed: () {
                                controller.reset();
                                Get.back();
                              },
                              child: SmallText(
                                text: 'Cancel',
                                textColor: kBlack,
                              )),
                          confirm: TextButton(
                              onPressed: () {
                                controller.success();
                                Get.back();
                                widget.auth.signOut();
                                1.seconds.delay().then((value) => Get.back());
                              },
                              child: SmallText(
                                text: 'Confirm',
                                textColor: Colors.red,
                              )),
                          title: "Alert!",
                          titleStyle:
                              kLargerTextStyle.copyWith(color: kMainColor),
                          content: Center(
                            child: MediumText(
                                text: "Do you want to sign out?",
                                textColor: kBlack),
                          )),
                      controller: controller),
                ),
                SizedBox(
                  height: 50.h,
                )
              ],
            ),
          );
        });
  }
}
