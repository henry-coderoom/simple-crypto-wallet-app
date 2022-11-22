import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_crypto_wallet/components/switch_wallet_model.dart';
import 'package:my_crypto_wallet/models/transfer_data_model.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:my_crypto_wallet/wallet_screens/deposit_screen.dart';
import 'package:my_crypto_wallet/wallet_screens/transfer_screen.dart';
import '../constants.dart';
import '../utils/keyboard.dart';
import '../utils/utils.dart';
import 'action_buttons.dart';

class TotalBalanceContainer extends StatefulWidget {
  final String walletId;
  final double totalBal;
  final bool isReloading;
  const TotalBalanceContainer({
    Key? key,
    required this.walletId,
    required this.totalBal,
    required this.isReloading,
  }) : super(key: key);

  @override
  State<TotalBalanceContainer> createState() => _TotalBalanceContainerState();
}

class _TotalBalanceContainerState extends State<TotalBalanceContainer> {
  @override
  void initState() {
    super.initState();
  }

  void _buttonMethod(String screen) async {
    final List<TransferData> assetList = await WalletConfig().getAssetList();
    WalletConfig()
        .showModalBox(context, buildSelectTokenBox(context, assetList, screen));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kDefaultThemeColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 8.0,
              spreadRadius: 0)
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          Center(
            child: Text(
              '\$${addCommas(truncateUSD(widget.totalBal))}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: kTextColorDarkest),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WalletID: ${widget.walletId}',
                style: const TextStyle(
                    fontSize: 16,
                    color: kTextColorDark,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  WalletConfig().showModalBox(context, const SwitchWallet());
                  KeyboardUtil.hideKeyboard(context);
                },
                child: Text(
                  'Change ⇲',
                  style: TextStyle(
                      fontSize: 16,
                      color: kDefaultThemeDarkestColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          IntrinsicWidth(
            child: Row(
              children: [
                TokenActionButtonWidget(
                  buttonText: 'Send',
                  icon: Icons.arrow_upward_outlined,
                  function: () => _buttonMethod('send'),
                ),
                TokenActionButtonWidget(
                  buttonText: 'Receive',
                  icon: Icons.arrow_downward_outlined,
                  function: () => _buttonMethod('deposit'),
                ),
                TokenActionButtonWidget(
                  buttonText: 'Buy',
                  icon: Icons.add_shopping_cart_rounded,
                  function: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column buildSelectTokenBox(
      BuildContext context, List<TransferData> assets, String screen) {
    final String headerText =
        (screen == 'send') ? 'Transfer Asset' : 'Deposit Asset';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15),
          child: Text(
            headerText,
            style: kAppBarTextStyle.copyWith(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final TransferData data = assets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      side: const BorderSide(
                        color: kBackgroundLight,
                      ),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (screen == 'send') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferScreen(
                                data: data,
                              ),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepositScreen(
                                data: data,
                              ),
                            ));
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            data.logoAsset,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Text('${data.tokenName} (${data.tokenNameShort})',
                            style: const TextStyle(
                                color: kTextColorDarkest,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ],
                    )),
              );
            },
          ),
        )
      ],
    );
  }
}
