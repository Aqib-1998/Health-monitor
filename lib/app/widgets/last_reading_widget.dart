import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

class LastReadingWidget extends StatelessWidget {
  final String reading;
  final String heading;
  final String imagePath;
  const LastReadingWidget(
      {Key? key,
      required this.reading,
      required this.heading,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: Get.width,
      margin: kAppCornerPadding,
      decoration: BoxDecoration(
          color: kMainColor,
          borderRadius: BorderRadius.circular(kContainerRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText(text: heading, textColor: kWhiteColor),
              // SizedBox(height: 10.h),
              LargeText(text: reading, textColor: kWhiteColor)
            ],
          ),
          SizedBox(),
          SvgPicture.asset(
            imagePath,
            color: kWhiteColor,
          )
        ],
      ),
    );
  }
}
