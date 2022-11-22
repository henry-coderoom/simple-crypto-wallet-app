// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextForm extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  final String hinText;
  final TextInputType textInputType;
  final bool hasSuffix;
  final focusNode;
  final maxLength;
  final suffixWidget;
  const CustomTextForm(
      {Key? key,
      required this.controller,
      required this.hasSuffix,
      this.focusNode,
      required this.hinText,
      required this.textInputType,
      required this.onChanged,
      this.suffixWidget,
      this.maxLength})
      : super(key: key);

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: kFormTextStyle,
      controller: widget.controller,
      onChanged: (String text) {
        widget.onChanged(text);
      },
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.done,
      keyboardType: widget.textInputType,
      maxLines: null,
      maxLength: widget.maxLength ?? 200,
      decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: kBackgroundLight,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          focusedBorder: kDefaultBorderDeco,
          enabledBorder: kDefaultBorderDeco,
          hintText: widget.hinText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: (widget.hasSuffix)
              ? widget.suffixWidget
              : const SizedBox.shrink()),
    );
  }
}
