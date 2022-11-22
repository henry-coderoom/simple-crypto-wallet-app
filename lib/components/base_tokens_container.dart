// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_crypto_wallet/utils/utils.dart';
import '../constants.dart';

class BaseTokensContainer extends StatefulWidget {
  final String name;
  final bool isReLoading;
  final String logoAsset;
  final String tokenNameShort;
  final String balance;
  final String tokenValueUsd;
  final tokenPrice;
  final double priceChange24h;

  const BaseTokensContainer({
    Key? key,
    required this.name,
    required this.priceChange24h,
    required this.tokenPrice,
    required this.tokenValueUsd,
    required this.balance,
    required this.logoAsset,
    required this.isReLoading,
    required this.tokenNameShort,
  }) : super(key: key);

  @override
  State<BaseTokensContainer> createState() => _BaseTokensContainerState();
}

class _BaseTokensContainerState extends State<BaseTokensContainer> {
  @override
  Widget build(BuildContext context) {
    final bool _isNegative = isNegative(widget.priceChange24h);

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: kBackgroundWhite,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 8.0,
              spreadRadius: 0)
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                            color: kTextColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, vertical: 6),
                      child: SvgPicture.asset(
                        widget.logoAsset,
                        height: 20,
                        width: 20,
                      ),
                    )
                  ],
                ),
                Text(
                  widget.balance,
                  style: TextStyle(
                      color: (widget.isReLoading)
                          ? Colors.black26
                          : kTextColorDarkest,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  '~\$${addCommas(widget.tokenValueUsd)}',
                  style: TextStyle(
                      color: (widget.isReLoading)
                          ? Colors.black26
                          : kTextColorDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '\$${addCommas(widget.tokenPrice.toString())}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextColorDarkest),
                  ),
                ),
                SizedBox(
                  child: (_isNegative)
                      ? Text(
                          '${widget.priceChange24h.toString()}%',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )
                      : Text(
                          '+${widget.priceChange24h.toString()}%',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
