import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/typography.dart';
import 'package:heatlth_monitor/app/modules/models/history_model.dart';
import 'package:heatlth_monitor/app/widgets/ripple_button.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

class MeasurementPage extends StatefulWidget {
  final String uid;
  final String deviceId;
  const MeasurementPage({Key? key, required this.uid, required this.deviceId})
      : super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

RxBool measure = false.obs;

class _MeasurementPageState extends State<MeasurementPage> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: kAppCornerPadding,
            child: LargeText(
                text: "Measurement of Heart Rate and SPO2",
                textColor: kMainColor),
          ),
          SizedBox(
            height: 100.h,
          ),
          Center(
            child: !measure.value
                ? Text("Please Put your finger on the\n sensor and press Start",
                    textAlign: TextAlign.center,
                    style: kSmallTextStyle.copyWith(
                        color: kBlack.withOpacity(0.65)))
                : Text("Measuring...",
                    textAlign: TextAlign.center,
                    style: kMediumTextStyle.copyWith(
                        color: kBlack.withOpacity(0.65))),
          ),
          SizedBox(
            height: 20.h,
          ),
          !measure.value
              ? RippleButton(onTap: () async {
                  measure.value = true;
                  await FirebaseDatabase.instance
                      .ref()
                      .child(widget.deviceId)
                      .update({'Case': 1});
                  String heartRate = "0", spo2 = "0", temperature = "0";
                  Map<dynamic, dynamic> values = {};
                  10.seconds.delay().then((value) async {
                    await FirebaseDatabase.instance
                        .ref()
                        .child(widget.deviceId)
                        .update({'Case': 0}).whenComplete(() async {
                      3.seconds.delay().then((value) async {
                        await FirebaseDatabase.instance
                            .ref()
                            .child(widget.deviceId)
                            .once()
                            .then((value) {
                          values =
                              value.snapshot.value! as Map<dynamic, dynamic>;
                          temperature = "${values["Temperature"]}";
                          spo2 = "${values["SPO2"]} %";
                          heartRate = "${values["BPM"]} BPM";
                        }).whenComplete(() {
                          History history = History(
                              temperature: temperature,
                              spo2: spo2,
                              bpm: heartRate,
                              dateTime: DateTime.now(),
                              id: "asdasdasd");

                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.uid)
                              .collection("History")
                              .add(history.toMap())
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(widget.uid)
                                .collection("History")
                                .doc(value.id)
                                .update({"id": value.id});
                            measure.value = false;

                            Get.defaultDialog(
                                barrierDismissible: false,
                                title: "Result",
                                titleStyle: kLargerTextStyle.copyWith(
                                    color: kMainColor),
                                content: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MediumText(
                                                text: "Heart Rate:",
                                                textColor: kMainColor),
                                            MediumText(
                                                text: heartRate,
                                                textColor: kMainColor)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MediumText(
                                                text: "SPO2:",
                                                textColor: kMainColor),
                                            MediumText(
                                                text: spo2,
                                                textColor: kMainColor)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: SmallText(
                                              text: "Back to Home",
                                              textColor: kWhiteColor))
                                    ],
                                  ),
                                ));
                          });
                        });
                      });
                    });
                  });
                })
              : Center(
                  child: SpinKitPumpingHeart(
                    color: kMainColor,
                    size: 100,
                    duration: Duration(seconds: 2),
                  ),
                ),
        ],
      );
    });
  }
}
