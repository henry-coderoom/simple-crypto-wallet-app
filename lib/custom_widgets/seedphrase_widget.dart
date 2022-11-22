import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants.dart';
import '../utils/utils.dart';

class SeedPhraseWidget extends StatelessWidget {
  const SeedPhraseWidget({
    Key? key,
    required String? seedPhrase,
  })  : _seedPhrase = seedPhrase,
        super(key: key);

  final String? _seedPhrase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                primary: kBackgroundLight,
                elevation: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Mnemonic Seed Phrase",
                    style: TextStyle(
                        fontSize: 14,
                        color: kTextColorLight,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '$_seedPhrase',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextColorDarkest),
                ),
                Center(
                  child: QrImage(
                    data: _seedPhrase!,
                    size: 150.0,
                  ),
                ),
                const Divider(
                  color: kTextColorDarkest,
                ),
                const Center(
                  child: Icon(
                    Icons.copy_all_sharp,
                    color: kTextColorDarkest,
                  ),
                ),
                const Center(
                  child: Text(
                    'Copy to clipboard',
                    style: TextStyle(color: kTextColorDarkest),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _seedPhrase));
              showToastOne(
                  context, 'Phrase Copied!', Icons.check_circle_outline, 1);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Text(
            "Be sure to copy and securely save your Seed Phrase and Private Key, you'll need them to recover your wallet. Do not disclose your Private Key or Seed Phrase, anybody with any of these information can transfer your tokens.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
