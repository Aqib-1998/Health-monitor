import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/typography.dart';
import 'package:heatlth_monitor/app/modules/pages/views/auth_view.dart';
import 'package:heatlth_monitor/app/widgets/custom_elevated_button.dart';
import 'package:heatlth_monitor/app/widgets/safe_area.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../services/auth.dart';
import '../../../widgets/custom_textfield.dart';

class AddDevice extends StatefulWidget {
  final String uid;
  final AuthBase auth;
  const AddDevice({Key? key, required this.uid, required this.auth})
      : super(key: key);

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

double height = Get.height, width = Get.width;
var deviceNameController = TextEditingController();
var deviceIdController = TextEditingController();
var devicePasswordController = TextEditingController();
final RoundedLoadingButtonController addDeviceController =
    RoundedLoadingButtonController();

class _AddDeviceState extends State<AddDevice> {
  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
              onPressed: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: kMainColor,
              )),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<dynamic>(
              stream:
                  FirebaseDatabase.instance.ref().child('All_Devices').onValue,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  );
                }
                Map<dynamic, dynamic> allDevices = snap.data.snapshot.value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: LargeText(
                          text: "Device Setup", textColor: kMainColor),
                    ),
                    Center(
                      child: MediumText(
                          text: "Connect to the Device", textColor: kBlack),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: kAppCornerPadding,
                      child: Text(
                        "Device Name",
                        style: kSmallTextStyle.copyWith(color: kMainColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    customTextField("e.g Kitchen", TextInputType.emailAddress,
                        deviceNameController),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: kAppCornerPadding,
                      child: Text(
                        "Device ID",
                        style: kSmallTextStyle.copyWith(color: kMainColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    customTextField(
                        "e.g 123456", TextInputType.number, deviceIdController),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: kAppCornerPadding,
                      child: Text(
                        "Device Password",
                        style: kSmallTextStyle.copyWith(color: kMainColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    PasswordTextField(
                        controller: devicePasswordController,
                        hintText: "***********"),
                    SizedBox(
                      height: 100.h,
                    ),
                    CustomElevatedButton(
                        icon: kAddWhiteSvg,
                        text: "Add Device",
                        ontap: () => addDevice(
                            addDeviceController: addDeviceController,
                            allDevices: allDevices,
                            deviceIdController: deviceIdController,
                            deviceNameController: deviceNameController,
                            devicePasswordController: devicePasswordController),
                        controller: addDeviceController),
                    SizedBox(
                      height: 50.h,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  void addDevice({
    required TextEditingController deviceNameController,
    required TextEditingController deviceIdController,
    required TextEditingController devicePasswordController,
    required RoundedLoadingButtonController addDeviceController,
    required Map<dynamic, dynamic> allDevices,
  }) {
    if (deviceNameController.text.isEmpty ||
        deviceIdController.text.isEmpty ||
        devicePasswordController.text.isEmpty) {
      Get.snackbar("error", "Please fill all the fields correctly",
          borderRadius: 15, snackPosition: SnackPosition.TOP);
      addDeviceController.error();

      2.seconds.delay().then((value) => addDeviceController.reset());
    } else {
      if (allDevices.containsKey(deviceIdController.text) &&
          allDevices[deviceIdController.text] ==
              devicePasswordController.text) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.uid)
            .collection('Connected Devices')
            .doc(deviceIdController.text)
            .set({
          'Device Name': deviceNameController.text,
          'Device Password': devicePasswordController.text,
          'Device Id': deviceIdController.text,
        }).whenComplete(() {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.uid)
              .update({'New user': false});
        });
        addDeviceController.success();
        2
            .seconds
            .delay()
            .then((value) => Get.offAll(() => AuthView(auth: widget.auth)));
      } else {
        Get.snackbar("error", "Please provide correct device's information",
            borderRadius: 15,
            snackPosition: SnackPosition.TOP,
            backgroundColor: kWhiteColor);
        addDeviceController.error();
        2.seconds.delay().then((value) => addDeviceController.reset());
      }
    }
  }
}
