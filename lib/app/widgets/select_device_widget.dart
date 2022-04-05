import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

class SelectDeviceWidget extends StatefulWidget {
  final String deviceId;
  final String deviceName;
  final VoidCallback ontap;
  final VoidCallback onLongPress;
  const SelectDeviceWidget(
      {Key? key,
      required this.deviceId,
      required this.deviceName,
      required this.ontap,
      required this.onLongPress})
      : super(key: key);

  @override
  State<SelectDeviceWidget> createState() => _SelectDeviceWidgetState();
}

class _SelectDeviceWidgetState extends State<SelectDeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      onLongPress: widget.onLongPress,
      child: Container(
        width: Get.width,
        height: 90.h,
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: kGrey,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 2.5,
                  spreadRadius: 2.5,
                  offset: Offset(2.5, 3.5))
            ],
            borderRadius: BorderRadius.circular(kContainerRadius)),
        child: Padding(
          padding: kAppCornerPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText(text: widget.deviceName, textColor: kMainColor),
              SizedBox(
                height: 5.h,
              ),
              SmallText(text: widget.deviceId, textColor: kMainColor)
            ],
          ),
        ),
      ),
    );
  }
}
