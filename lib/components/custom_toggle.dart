import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/constants.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color buttonColor;
  final Color textColor;

  const AnimatedToggle({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool? _initialValue;

  @override
  void initState() {
    _getInitialValue();
    super.initState();
  }

  _getInitialValue() {
    setState(() {
      _initialValue = Hive.box('wallets').get('isMainNet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.38,
      height: Get.width * 0.07,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              _getInitialValue();
              var value = true;
              if (_initialValue!) {
                value = false;
              }
              widget.onToggleCallback(value);
              setState(() {
                _initialValue = value;
              });
            },
            child: Container(
              width: Get.width * 0.38,
              height: Get.width * 0.07,
              decoration: ShapeDecoration(
                color: kDefaultThemeDarkerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Text(
                      widget.values[index],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kTextColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                _initialValue! ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 2, left: 2),
              width: Get.width * 0.19,
              height: Get.width * 0.06,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _initialValue! ? widget.values[0] : widget.values[1],
                style: const TextStyle(
                  fontSize: 14,
                  color: kTextColorDarkest,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
