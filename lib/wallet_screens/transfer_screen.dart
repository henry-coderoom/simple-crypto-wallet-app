// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/api_service/api_services.dart';
import 'package:my_crypto_wallet/components/center_loader.dart';
import 'package:my_crypto_wallet/components/custom_text_form.dart';
import 'package:my_crypto_wallet/components/default_button.dart';
import 'package:my_crypto_wallet/custom_widgets/form_buttons_widget.dart';
import 'package:my_crypto_wallet/size_config.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:my_crypto_wallet/wallet_screens/confirm_tx_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../custom_widgets/appbar_widget.dart';
import '../models/transfer_data_model.dart';
import '../utils/keyboard.dart';
import '../utils/utils.dart';

class TransferScreen extends StatefulWidget {
  final TransferData data;

  const TransferScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _recAddressController = TextEditingController();
  final FocusNode _amountTextFieldNode = FocusNode();
  final TextEditingController _sendAmountController = TextEditingController();

  bool _sending = false;
  bool _isLoading = true;
  String? _receiver;
  String? _hashKey;
  String? _amount;
  double? _tokenBalance;
  double? _coinPrice;
  double? _tokenBalanceUsd;
  String? _sendAmtUsd;
  bool _showSendAmtUsd = false;
  bool _isValidAddress = true;
  final bool _isMainnet = Hive.box('wallets').get('isMainNet');

  final TextStyle _errTextStyle = const TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    _fetchTokenBalance();
    super.initState();
  }

  _validateAddress(String value) {
    if (_recAddressController.text.isNotEmpty) {
      setState(() {
        _isValidAddress = validateAddress(value.toString(), widget.data.chain);
      });
    } else {
      setState(() {
        _isValidAddress = true;
      });
    }
  }

  _fetchTokenBalance() async {
    final priceData =
        await ApiServices().getCoinPriceData(widget.data.tokenNameGecko);
    _coinPrice = priceData?.token.usd;
    _tokenBalance = await widget.data.tokenBalance();
    setState(() {
      _tokenBalanceUsd = _coinPrice! * _tokenBalance!;
      _isLoading = false;
    });
  }

  _showSuccess(double enteredAmt, String hash) {
    setState(() {
      _hashKey = hash;
    });
    if (_hashKey != '' && _hashKey != 'low_bal') {
      setState(() {
        _amount = enteredAmt.toString();

        _receiver = _recAddressController.text.toString();
        _recAddressController.text = '';
        _sendAmountController.text = '';
        _showSendAmtUsd = false;
      });
      WalletConfig().showModalBox(
          context, buildTokenSentWidget(widget.data.tokenNameShort));
    } else if (_hashKey == 'low_bal') {
      showToastOne(
          context,
          'Balance is too low for gas + the amount you want to send.',
          Icons.error_outline,
          4);
    } else {
      WalletConfig().showModalBox(
          context, buildTxFailedWidget(widget.data.tokenNameShort, _hashKey!));
    }
  }

  _resetSendingState(bool value) {
    setState(() {
      _sending = value;
    });
  }

  _launchURL(
    String _url,
  ) async {
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(
      url,
    )) throw 'Could not open $_url';
  }

  @override
  void dispose() {
    _recAddressController.dispose();
    _sendAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: kTextColorDark,
        backgroundColor: kDefaultThemeColor,
        title: AppBarWidget(
          title: 'Transfer ${widget.data.tokenName}',
          showNetwork: true,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 2),
                            blurRadius: 8.0,
                            spreadRadius: 0)
                      ],
                      color: kDefaultThemeDarkestColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(
                              child: Text(
                                'Available',
                                style: TextStyle(
                                    color: kTextColorLight,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: SvgPicture.asset(
                                widget.data.logoAsset,
                                height: 20,
                                width: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: SizedBox(
                          child: (_isLoading)
                              ? const CenterLoading(loadingText: '')
                              : Text(
                                  '${_tokenBalance!} ${widget.data.tokenNameShort}',
                                  style: const TextStyle(
                                      color: kTextColorWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 4),
                          child: (_isLoading)
                              ? const SizedBox.shrink()
                              : Text(
                                  '~\$${truncateUSD(_tokenBalanceUsd!)}',
                                  style: const TextStyle(
                                      color: kTextColorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
                  child: CustomTextForm(
                    controller: _recAddressController,
                    hasSuffix: true,
                    hinText: "Enter recipient address",
                    textInputType: TextInputType.multiline,
                    onChanged: (value) {
                      _validateAddress(value);
                    },
                    suffixWidget: FormButtonWidget(action1: () {
                      Clipboard.getData(Clipboard.kTextPlain)
                          .then((value) async {
                        setState(() {
                          _recAddressController.text = (value?.text)!;
                        });
                        _validateAddress(
                            _recAddressController.text.toString())!;
                      });
                    }, action2: (text) {
                      setState(() {
                        _recAddressController.text = text;
                      });
                      _validateAddress(text)!;
                    }),
                  ),
                ),
                SizedBox(
                  child: (_isValidAddress)
                      ? const SizedBox.shrink()
                      : const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            'Invalid address',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CustomTextForm(
                    maxLength: 9,
                    focusNode: _amountTextFieldNode,
                    controller: _sendAmountController,
                    hasSuffix: false,
                    hinText: "Enter amount in ${widget.data.tokenNameShort}",
                    textInputType: TextInputType.number,
                    onChanged: (value) {
                      if (value == '.') {
                        const String leadingZero = '0';
                        setState(() {
                          _sendAmountController.text = leadingZero +
                              _sendAmountController.text.toString();
                        });
                      }
                      if (value.isNotEmpty && validateAmount(value)) {
                        final amt = double.parse(value) * _coinPrice!;
                        final amtWithCommas = addCommas(truncateUSD(amt));
                        setState(() {
                          _sendAmtUsd = amtWithCommas;
                          _showSendAmtUsd = true;
                        });
                      } else {
                        setState(() {
                          _showSendAmtUsd = false;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    child: (_showSendAmtUsd)
                        ? Text(
                            "~\$$_sendAmtUsd",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kTextColorDark,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            buildSendButton(context)
          ],
        ),
      ),
    );
  }

  Container buildSendButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 40, bottom: 50),
        child: DefaultButton(
          onTap: (_sending || _isValidAddress == false)
              ? () {}
              : () async {
                  if (_sendAmountController.text.isNotEmpty &&
                      _recAddressController.text.isNotEmpty &&
                      _recAddressController.text.toLowerCase() !=
                          widget.data.address) {
                    KeyboardUtil.hideKeyboard(context);
                    _resetSendingState(true);
                    final isValid =
                        validateAmount(_sendAmountController.text.toString());
                    if (isValid == true) {
                      final double enteredAmt =
                          double.parse(_sendAmountController.text.toString());
                      if (enteredAmt + 0.00004 > _tokenBalance!) {
                        showToastOne(context, 'Insufficient balance',
                            Icons.error_outline, 2);
                        _resetSendingState(false);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmTxScreen(
                                      data: widget.data,
                                      recipient: _recAddressController.text
                                          .trim()
                                          .toString(),
                                      success: (value) {
                                        _showSuccess(enteredAmt, value);
                                      },
                                      enteredAmt: enteredAmt,
                                      price: _coinPrice!,
                                    )));
                        _resetSendingState(false);
                      }
                    } else {
                      _resetSendingState(false);
                      showToastOne(context, 'Please enter a valid amount.',
                          Icons.error_outline, 2);
                    }
                  } else if (_recAddressController.text.isNotEmpty &&
                      _recAddressController.text.toLowerCase() ==
                          widget.data.address) {
                    showToastOne(context, 'You entered your own address?',
                        Icons.error_outline, 3);
                  } else {
                    showToastOne(
                        context, 'Empty field(s)!', Icons.error_outline, 2);
                  }
                },
          padding: getProportionateScreenWidth(100),
          radius: 25,
          withIcon: false,
          textColor: kTextColorWhite,
          bgColor: kDefaultThemeDarkestColor,
          borderColor: Colors.transparent,
          buttonText: 'Continue',
        ));
  }

  Column buildTokenSentWidget(String token) {
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
        Center(
          child: Text(
            'You successfully sent $_amount $token to $_receiver, balance will reflect once the transaction is confirmed. Transaction hash:',
            style: const TextStyle(
                color: kTextColorDarkest,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              primary: Colors.grey.shade200,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              showToastOne(context, 'Copied!', Icons.check_circle, 1);
              Clipboard.setData(ClipboardData(text: _hashKey));
            },
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  _hashKey!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kTextColorDark,
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon(
                    Icons.copy_outlined,
                    size: 20,
                    color: kTextColorDark,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
            TextButton(
                onPressed: (_isMainnet)
                    ? () {
                        if (token == 'ETH') {
                          _launchURL('https://etherscan.io/tx/$_hashKey');
                        } else if (token == 'BNB') {
                          _launchURL('https://bscscan.com/tx/$_hashKey');
                        } else if (token == 'BTC') {
                          _launchURL(
                              'https://www.blockchain.com/btc/tx/$_hashKey');
                        }
                      }
                    : () {
                        if (token == 'ETH') {
                          _launchURL(
                              'https://rinkeby.etherscan.io/tx/$_hashKey');
                        } else if (token == 'BNB') {
                          _launchURL(
                              'https://testnet.bscscan.com/tx/$_hashKey');
                        } else if (token == 'BTC') {
                          _launchURL(
                              'https://www.blockchain.com/btc-testnet/tx/$_hashKey');
                        }
                      },
                child: const Text(
                  'See Txn Details',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ],
        )
      ],
    );
  }

  Column buildTxFailedWidget(String token, String eCode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cancel,
          size: 50,
          color: Colors.yellow.shade900,
        ),
        const SizedBox(
          height: 0,
        ),
        SizedBox(
          child: (eCode == 'low_bal')
              ? Center(
                  child: ListTile(
                    title: Text(
                      'Your available balance is not enough to cover for gas fee and the amount you\'re trying to send.',
                      style: _errTextStyle,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Note: only transactions with at least 1 confirmation on the $token network are available for spending.',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : ListTile(
                  title: Center(
                    child: Text(
                      'Transaction failed',
                      style: _errTextStyle,
                    ),
                  ),
                  subtitle: Text(
                      '*Your available balance might be on hold if there is a pending transaction, please wait for the transaction to be confirmed.\n*Be sure the address you entered is a valid $token address.\n*Also check your internet connection or contact support if this persists.',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
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
