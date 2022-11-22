// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:my_crypto_wallet/components/center_loader.dart';
import 'package:my_crypto_wallet/components/default_button.dart';
import 'package:my_crypto_wallet/models/transfer_data_model.dart';
import 'package:my_crypto_wallet/utils/utils.dart';

import '../constants.dart';
import '../custom_widgets/appbar_widget.dart';
import 'package:web3dart/web3dart.dart' as web3;
import '../size_config.dart';

class ConfirmTxScreen extends StatefulWidget {
  final TransferData data;
  final recipient;
  final double enteredAmt;
  final double price;
  final Function(String hash) success;
  const ConfirmTxScreen(
      {Key? key,
      required this.data,
      required this.recipient,
      required this.success,
      required this.enteredAmt,
      required this.price})
      : super(key: key);

  @override
  State<ConfirmTxScreen> createState() => _ConfirmTxScreenState();
}

class _ConfirmTxScreenState extends State<ConfirmTxScreen> {
  bool _isLoading = false;
  String? _gasAmt;
  String? _gasAmtUsd;
  String? _totalAmt;
  String? _totalAmtUsd;
  bool _isInit = true;
  final titleTextStyle = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: kTextColorDarkest);
  final subtitleTextStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: kTextColorDark);

  Future<double> _fetchGasFee() async {
    if (widget.data.chain == 'eth') {
      final sendAmt = toEtherAmt(widget.enteredAmt);
      final sender = web3.EthereumAddress.fromHex(widget.data.address);
      final toAddress = web3.EthereumAddress.fromHex(widget.recipient);
      final Client httpClient = Client();
      final web3.Web3Client ethClient = web3.Web3Client(
          "https://rinkeby.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
          httpClient);
      final web3.Web3Client client = widget.data.client;
      final bigGasAmt = await ethClient.getGasPrice();

      // final double gasAmount = (bigGasAmt.toInt() / 100000000);
      final ethhh = truncate(bigGasAmt.getValueInUnit(web3.EtherUnit.ether));
      return double.parse(ethhh!);
    } else if (widget.data.chain == 'btc') {
      const double gasAmount = 0.00004;
      return gasAmount;
    }
    return 0.00;
  }

  _setTxData() async {
    final double gasAmount = await _fetchGasFee();
    final sendAmtUsd = truncateUSD(widget.enteredAmt * widget.price);
    setState(() {
      _gasAmt = truncateAmt(gasAmount).toString();
      _gasAmtUsd = truncateUSD((widget.price * gasAmount));
      _totalAmt = truncateAmt((widget.enteredAmt + gasAmount));
      _totalAmtUsd =
          truncateUSD((double.parse(_gasAmtUsd!) + double.parse(sendAmtUsd)));
      _isInit = false;
    });
  }

  Future _getHash() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await widget.data.sendMethod(widget.enteredAmt, widget.recipient);
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
    widget.success(response);
  }

  @override
  void initState() {
    _setTxData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final String tokenShortName = widget.data.tokenNameShort;
    final String sendAmt = '${widget.enteredAmt} $tokenShortName';
    final double sendAmtUsd = widget.enteredAmt * widget.price;
    final String sendAmtUsdString = truncateUSD(sendAmtUsd);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: kTextColorDark,
          backgroundColor: kDefaultThemeColor,
          title: const AppBarWidget(
            title: 'Confirm Transaction',
            showNetwork: true,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45),
              child: Card(
                color: kDefaultThemeDarkestColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Wrap(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: SvgPicture.asset(
                          widget.data.logoAsset,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Transaction Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kTextColorWhite),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: kBackgroundWhite,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildSendToColumn(
                                    'Send to:',
                                    shrinkAddr(widget.recipient).toString(),
                                    Linecons.user),
                                buildSendToColumn(
                                    'From:',
                                    shrinkAddr(widget.data.address).toString(),
                                    Linecons.wallet),
                              ],
                            ),
                          ),
                          buildAmountRow(
                              'Amount:', '$sendAmt (\$$sendAmtUsdString)'),
                          Wrap(
                            children: (_isInit)
                                ? [
                                    const CenterLoading(
                                        loadingText: 'Estimating gas')
                                  ]
                                : [
                                    buildAmountRow('Gas fee:',
                                        '$_gasAmt $tokenShortName (\$$_gasAmtUsd)'),
                                    const Divider(
                                      color: kTextColorLight,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buildAmountRow('Total:',
                                        '$_totalAmt $tokenShortName (\$$_totalAmtUsd)'),
                                  ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: DefaultButton(
                onTap: (_isLoading || _isInit)
                    ? () => null
                    : () {
                        _getHash();
                      },
                padding: getProportionateScreenWidth(100),
                radius: 25,
                withIcon: false,
                textColor: kTextColorWhite,
                bgColor: (_isLoading || _isInit)
                    ? Colors.grey
                    : kDefaultThemeDarkestColor,
                borderColor: Colors.transparent,
                buttonText: (_isLoading) ? 'Sending...' : 'Confirm',
              ),
            )
          ],
        ));
  }

  Padding buildAmountRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleTextStyle,
          ),
          Text(
            subtitle,
            style: subtitleTextStyle,
          ),
        ],
      ),
    );
  }

  Column buildSendToColumn(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: kDefaultThemeDarkerColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: titleTextStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          subtitle,
          style: subtitleTextStyle,
        )
      ],
    );
  }
}
