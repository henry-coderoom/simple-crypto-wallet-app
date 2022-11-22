// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton(
      {Key? key,
      required this.onTap,
      this.icon,
      required this.padding,
      required this.radius,
      required this.withIcon,
      required this.textColor,
      required this.bgColor,
      required this.borderColor,
      required this.buttonText})
      : super(key: key);
  final Function() onTap;
  final double radius;
  final double padding;
  final icon;
  final bool withIcon;
  final String buttonText;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  @override
  State<DefaultButton> createState() => DefaultButtonState();
}

class DefaultButtonState extends State<DefaultButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: widget.bgColor,
          side: BorderSide(
            color: widget.borderColor,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.radius),
            ),
          ),
        ),
        onPressed: (_isLoading)
            ? () {}
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.onTap();
                setState(() {
                  _isLoading = false;
                });
              },
        child: IntrinsicWidth(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.padding, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: (_isLoading)
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: kTextColorWhite,
                            strokeWidth: 1.5,
                          ),
                        )
                      : SizedBox(
                          child: (widget.withIcon == true)
                              ? Icon(
                                  widget.icon,
                                  size: 16,
                                  color: widget.textColor,
                                )
                              : const SizedBox.shrink(),
                        ),
                ),
                SizedBox(
                  width: (widget.withIcon == true) ? 5 : 0,
                ),
                Expanded(
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                        color: widget.textColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
