import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../data/constants.dart';

class CustomElevatedButton extends StatefulWidget {
  final String icon;
  final String text;
  final VoidCallback ontap;
  final RoundedLoadingButtonController controller;
  const CustomElevatedButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.ontap,
      required this.controller})
      : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: Get.width,
      margin: kAppCornerPadding,
      child: RoundedLoadingButton(
          borderRadius: kButtonRadius,
          color: kMainColor,
          successColor: kMainColor,
          controller: widget.controller,
          onPressed: widget.ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(widget.icon),
              SizedBox(
                width: 5,
              ),
              SmallText(text: widget.text, textColor: kWhiteColor)
            ],
          )),
      // child: ElevatedButton.icon(
      //     icon: SvgPicture.asset(icon),
      //     onPressed: ontap,
      //     label: SmallText(
      //       text: text,
      //       textColor: kWhiteColor,
      //     )),
    );
  }
}
