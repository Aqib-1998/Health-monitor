import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';

import '../data/constants.dart';

class RippleButton extends StatelessWidget {
  final VoidCallback onTap;
  const RippleButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AvatarGlow(
      glowColor: kMainColor,
      endRadius: 100.r,
      animate: true,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: RawMaterialButton(
          onPressed: onTap,
          elevation: 2.0,
          splashColor: kMainColor,
          focusColor: kMainColor,
          hoverColor: kMainColor,
          highlightColor: kMainColor,

          constraints: BoxConstraints(minHeight: 150.h, minWidth: 100.w),
          fillColor: kMainColor,
          child: MediumText(text: "START", textColor: kWhiteColor),
          // padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
      ),
    ));
  }
}
