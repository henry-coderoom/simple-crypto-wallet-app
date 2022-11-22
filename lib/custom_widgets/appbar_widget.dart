import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
    required this.showNetwork,
  }) : super(key: key);

  final String title;
  final bool showNetwork;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final bool _isMainet = Hive.box('wallets').get('isMainNet');
  @override
  Widget build(BuildContext context) {
    final String _currentNet = (_isMainet) ? 'MAINNET' : 'TESTNET';
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Text(
            widget.title,
            style: kAppBarTextStyle,
          ),
        ),
        SizedBox(
          child: (widget.showNetwork)
              ? Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(
                    color: kDefaultThemeDarkerColor, width: 1)),
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              _currentNet,
              style: TextStyle(
                  color: kDefaultThemeDarkerColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}