import 'package:flutter/material.dart';
import 'package:heatlth_monitor/app/data/constants.dart';

class SafeAreaWrapper extends StatelessWidget {
  final Widget child;
  const SafeAreaWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: SafeArea(child: child),
    );
  }
}
