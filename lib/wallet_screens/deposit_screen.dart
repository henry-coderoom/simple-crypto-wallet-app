import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_crypto_wallet/models/transfer_data_model.dart';
import 'package:my_crypto_wallet/size_config.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../components/action_buttons.dart';
import '../constants.dart';
import '../custom_widgets/appbar_widget.dart';
import '../utils/utils.dart';

class DepositScreen extends StatefulWidget {
  final TransferData data;
  const DepositScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: kTextColorDark,
          backgroundColor: kDefaultThemeColor,
          title: AppBarWidget(
            title: 'Deposit ${widget.data.tokenName}',
            showNetwork: true,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(0, 8),
                          blurRadius: 8.0,
                          spreadRadius: 5)
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.tokenName,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10),
                            child: SvgPicture.asset(
                              widget.data.logoAsset,
                              height: 25,
                              width: 25,
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: QrImage(
                          data: widget.data.address,
                          size: 250.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          widget.data.address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Text(
                    'Share your address or scan the bar code to deposit ${widget.data.tokenName} tokens.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: kTextColorDarkest),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TokenActionButtonWidget(
                      buttonText: 'Copy',
                      icon: Icons.copy,
                      function: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.data.address));
                        showToastOne(
                            context,
                            '${widget.data.tokenNameShort} address Copied!',
                            Icons.check_circle_outline,
                            2);
                      },
                    ),
                    TokenActionButtonWidget(
                      buttonText: 'Share',
                      icon: Icons.share,
                      function: () => null,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
