import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/modules/models/history_model.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

import '../data/constants.dart';

class HistoryWidget extends StatelessWidget {
  final History history;
  final VoidCallback onLongPress;
  const HistoryWidget(
      {Key? key, required this.history, required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      child: Container(
        width: Get.width,
        height: 70.h,
        margin: kAppCornerPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kContainerRadius),
          color: kGrey,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(text: "Heart Rate: ", textColor: kBlack),
                      SmallText(text: history.bpm, textColor: kMainColor)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(text: "Temperature: ", textColor: kBlack),
                      SmallText(
                          text:
                              "${double.parse(history.temperature).toStringAsFixed(1)} °C",
                          textColor: kMainColor)
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(text: "SPO2: ", textColor: kBlack),
                      SmallText(text: history.spo2, textColor: kMainColor)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(text: "D/T: ", textColor: kBlack),
                      SmallText(
                          text: formatDate(history.dateTime, [
                            dd,
                            ' ',
                            M,
                            ', ',
                            yyyy,
                            '/',
                            HH,
                            ':',
                            nn,
                            ':',
                            ss
                          ]),
                          textColor: kBlack)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
