import 'package:flutter/material.dart';

import '../constants.dart';

class TokenActionButtonWidget extends StatefulWidget {
  final String buttonText;
  final IconData icon;
  final Function() function;
  const TokenActionButtonWidget(
      {Key? key,
      required this.icon,
      required this.buttonText,
      required this.function})
      : super(key: key);

  @override
  State<TokenActionButtonWidget> createState() =>
      _TokenActionButtonWidgetState();
}

class _TokenActionButtonWidgetState extends State<TokenActionButtonWidget> {
  bool _isButtonLoading = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kDefaultThemeDarkerColor,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isButtonLoading = true;
                });
                await widget.function();
                setState(() {
                  _isButtonLoading = false;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: (_isButtonLoading)
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.white,
                          ),
                          height: 16,
                          width: 16,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        size: 22,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Text(
              widget.buttonText,
              style: const TextStyle(
                  color: kTextColorDarkest, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
