import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/constants.dart';

class CenterLoading extends StatefulWidget {
  final String loadingText;
  const CenterLoading({Key? key, required this.loadingText}) : super(key: key);

  @override
  State<CenterLoading> createState() => _CenterLoadingState();
}

class _CenterLoadingState extends State<CenterLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              color: kDefaultThemeDarkerColor,
              strokeWidth: 1.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: (widget.loadingText == '') ? 0 : 8.0),
            child: Text(
              widget.loadingText,
              style: const TextStyle(
                  fontSize: 16,
                  color: kTextColorLight,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
