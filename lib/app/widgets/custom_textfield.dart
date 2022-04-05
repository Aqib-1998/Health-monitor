import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/typography.dart';

OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(color: Colors.transparent));

Widget customTextField(String hintText, TextInputType textInputType,
    TextEditingController controller) {
  return Theme(
    data: ThemeData(primaryColor: kGrey),
    child: Padding(
      padding: kAppCornerPadding,
      child: TextField(
        controller: controller,
        cursorColor: kMainColor,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        autofocus: false,
        style: kMediumTextStyle,
        decoration: InputDecoration(
            border: outlineBorder,
            focusedBorder: outlineBorder,
            enabledBorder: outlineBorder,
            errorBorder: outlineBorder,
            disabledBorder: outlineBorder,
            filled: true,
            fillColor: kMainColor.withOpacity(0.05),
            hintText: hintText,
            hintStyle:
                kMediumTextStyle.copyWith(color: kBlack.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
      ),
    ),
  );
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

bool visible = true;

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kAppCornerPadding,
      child: TextField(
        controller: widget.controller,
        cursorColor: kMainColor,
        obscureText: visible ? true : false,
        textInputAction: TextInputAction.next,
        autofocus: false,
        style: kMediumTextStyle,
        decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visible = !visible;
                });
              },
              child: !visible
                  ? const Icon(
                      Icons.visibility,
                      color: Colors.black54,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: Colors.black54,
                    ),
            ),
            border: outlineBorder,
            focusedBorder: outlineBorder,
            enabledBorder: outlineBorder,
            errorBorder: outlineBorder,
            disabledBorder: outlineBorder,
            filled: true,
            fillColor: kMainColor.withOpacity(0.05),
            hintText: widget.hintText,
            hintStyle:
                kMediumTextStyle.copyWith(color: kBlack.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
      ),
    );
  }
}
