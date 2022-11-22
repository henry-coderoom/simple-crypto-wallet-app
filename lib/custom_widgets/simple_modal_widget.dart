import 'package:flutter/material.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:my_crypto_wallet/constants.dart';

class SimpleModalWidget extends StatefulWidget {
  const SimpleModalWidget({Key? key}) : super(key: key);

  @override
  State<SimpleModalWidget> createState() => _SimpleModalWidgetState();
}

class _SimpleModalWidgetState extends State<SimpleModalWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          MfgLabs.ok_circled,
          size: 50,
          color: Colors.green,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          kWalletCreatedText,
          style: TextStyle(
              color: kTextColorDarkest,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
