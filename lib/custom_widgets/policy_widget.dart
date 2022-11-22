import 'package:flutter/material.dart';

import '../constants.dart';

class PolicyWidget extends StatefulWidget {
  final Widget switchWidget;
  const PolicyWidget({Key? key, required this.switchWidget}) : super(key: key);

  @override
  State<PolicyWidget> createState() => _PolicyWidgetState();
}

class _PolicyWidgetState extends State<PolicyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          widget.switchWidget,
          const SizedBox(
            width: 8,
          ),
          const Expanded(
            child: Text(
              kPolicyText,
              style:
                  TextStyle(color: kTextColorDark, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
