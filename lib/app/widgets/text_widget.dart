import 'package:flutter/material.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/typography.dart';

class LargeText extends StatelessWidget {
  final String text;
  final Color textColor;
  const LargeText({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kLargerTextStyle.copyWith(
          color: textColor, fontWeight: FontWeight.bold),
    );
  }
}

class MediumText extends StatelessWidget {
  final String text;
  final Color textColor;
  const MediumText({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kMediumTextStyle.copyWith(
          color: textColor, fontWeight: FontWeight.bold),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final Color textColor;
  const SmallText({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kSmallTextStyle.copyWith(
          color: textColor, fontWeight: FontWeight.normal),
    );
  }
}
