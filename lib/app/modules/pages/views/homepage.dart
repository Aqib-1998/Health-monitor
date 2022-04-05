import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/modules/models/history_model.dart';
import 'package:heatlth_monitor/app/widgets/last_reading_widget.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

class HomePage extends StatefulWidget {
  final String deviceId;
  final String uid;
  const HomePage({Key? key, required this.deviceId, required this.uid})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String temperature = "", spo2 = "", bpm = "";

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: kAppCornerPadding,
            child:
                LargeText(text: "Real-Time Temperature", textColor: kMainColor),
          ),
          SizedBox(
            height: 20.h,
          ),
          StreamBuilder<dynamic>(
            stream:
                FirebaseDatabase.instance.ref().child(widget.deviceId).onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              return Center(
                child: LargeText(
                    text: (snapshot.data!.snapshot.value!["Temperature"])
                            .toStringAsFixed(1) +
                        " °C",
                    textColor: kBlack),
              );
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: kAppCornerPadding,
            child: LargeText(text: "Health Monitor", textColor: kMainColor),
          ),
          Padding(
            padding: kAppCornerPadding,
            child: SmallText(
                text: "Last Measured Reading",
                textColor: kBlack.withOpacity(0.6)),
          ),
          SizedBox(
            height: 20.h,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.uid)
                  .collection("History")
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  temperature = "-";
                  spo2 = "-";
                  bpm = "-";
                }

                if (snapshot.data!.docs.isNotEmpty) {
                  History lastSavedHistory = History.fromMap(
                      snapshot.data!.docs[0].data() as Map<String, dynamic>);
                  log(lastSavedHistory.dateTime.toString());
                  temperature = double.parse(lastSavedHistory.temperature)
                          .toStringAsFixed(1) +
                      " °C";
                  bpm = lastSavedHistory.bpm;
                  spo2 = lastSavedHistory.spo2;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LastReadingWidget(
                        reading: temperature,
                        heading: "Temperature",
                        imagePath: kTemeratureSvg),
                    SizedBox(
                      height: 30.h,
                    ),
                    LastReadingWidget(
                        reading: spo2, heading: "SPO2", imagePath: kSpo2Svg),
                    SizedBox(
                      height: 30.h,
                    ),
                    LastReadingWidget(
                        reading: bpm,
                        heading: "Heart Rate",
                        imagePath: kHeartrateSvg),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
