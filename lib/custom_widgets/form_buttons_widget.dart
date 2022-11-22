import 'package:flutter/material.dart';

import '../wallet_screens/qr_reader_screen.dart';

class FormButtonWidget extends StatefulWidget {
  final Function() action1;
  final Function(String scannedText) action2;
  const FormButtonWidget(
      {Key? key, required this.action1, required this.action2})
      : super(key: key);

  @override
  State<FormButtonWidget> createState() => _FormButtonWidgetState();
}

class _FormButtonWidgetState extends State<FormButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () async {
            widget.action1();
          },
          child: const Text(
            'Paste',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeReaderScreen(
                      onScanned: (scannedAddress) {
                        widget.action2(scannedAddress.toString());
                      },
                      title: 'Scan Barcode',
                    ),
                  ));
            },
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.blue,
            ))
      ],
    );
  }
}
