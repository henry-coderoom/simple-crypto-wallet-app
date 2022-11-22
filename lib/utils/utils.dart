import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/constants.dart';
import 'package:my_crypto_wallet/size_config.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:oktoast/oktoast.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3;
import '../models/walletModel.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

simpleAlert(BuildContext context, Widget content) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: kBackgroundWhite,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: content));
}

showBetterSnackBar(
  BuildContext context,
  String text,
  int timer,
  Function() action,
  String label,
  IconData icon,
  Color iconColor,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: label,
        onPressed: () {
          action();
        },
      ),
      duration: Duration(seconds: timer),
      content: IntrinsicWidth(
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showToastOne(BuildContext context, String text, IconData icon, int timer) {
  SizeConfig().init(context);
  return showToastWidget(
      Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.all(10),
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(70)),
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: Duration(seconds: timer));
}

bool validateAddress(String address, String chain) {
  if (chain == 'eth') {
    // final RegExp _basicAddress =
    //     RegExp(r'^(0x)?[0-9a-f]{40}', caseSensitive: false);
    return isValidEthereumAddress(address);
  } else if (chain == 'btc') {
    return isBitcoinWalletValid(address);
  }
  return false;
}

bool validateAmount(String number) {
  final valid = double.tryParse(number) != null;
  if (valid == false) {
    return valid;
  } else {
    final isVal = checkZero(double.tryParse(number));
    return isVal;
  }
}

bool checkZero(dynamic number) {
  final wholeNumber = number * 10000000;
  if (wholeNumber == 0) {
    return false;
  } else {
    return true;
  }
}

bool isNegative(double value) {
  return value < 0;
}

String addCommas(String value) {
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc;
  mathFunc = (Match match) => '${match[1]},';
  final res = value.replaceAllMapped(reg, mathFunc);
  return res;
}

String? truncate(double? amt) {
  final String? bal =
      (amt == 0.0) ? amt?.toStringAsFixed(1) : amt?.toStringAsFixed(7);
  return bal;
}

String? truncateAmt(double? amt) {
  final String? bal = amt?.toStringAsFixed(7);
  return bal;
}

String truncateUSD(double amt) {
  final String bal = amt.toStringAsFixed(2);
  return bal;
}

String shrinkAddr(String address) {
  final shortAddr =
      address.substring(0, 6) + '...' + address.substring(address.length - 4);
  return shortAddr;
}

web3.EtherAmount toEtherAmt(double enteredAmt) {
  const String zeros = '00000000';
  final int firstNumbers = enteredAmt.toInt();
  final String firstNumAsString = firstNumbers.toString();
  final String lastNum = enteredAmt.toString().split('.')[1].substring(0);
  final int lastNumLen = lastNum.length;
  final bigLastNumber = lastNum + zeros.substring(lastNumLen);
  final String myNewAmt = firstNumAsString + bigLastNumber;
  final int myIntAmt = int.parse(myNewAmt);
  final bigAmount = BigInt.from(myIntAmt * 10000000000);
  web3.EtherAmount finalAmt = web3.EtherAmount.inWei(bigAmount);
  return finalAmt;
}

Future<double> ethAddressBalance(
    String address, web3.Web3Client tokenClient) async {
  web3.EthereumAddress userAddress = EthereumAddress.fromHex(address);
  final ethAmount = await tokenClient.getBalance(userAddress);
  final ethBalance = truncate(ethAmount.getValueInUnit(web3.EtherUnit.ether));
  final double balance = double.parse(ethBalance.toString());
  return balance;
}

Future<String> sendEthToken(String receiver, web3.EtherAmount amt,
    web3.Web3Client tokenClient, int id) async {
  final UserWalletsModel _activeWallet = WalletConfig().getWallet();
  final String ethPrivKey = _activeWallet.ethPrivKey;
  final String ethAddress = _activeWallet.ethAddress;
  web3.EthPrivateKey key = web3.EthPrivateKey.fromHex(ethPrivKey);
  web3.EthereumAddress targetAddress = web3.EthereumAddress.fromHex(receiver);
  web3.EthereumAddress senderAddress = web3.EthereumAddress.fromHex(ethAddress);
  web3.Transaction transaction = web3.Transaction().copyWith(
      from: senderAddress, to: targetAddress, value: amt, maxGas: 100000);
  final result = tokenClient.sendTransaction(key, transaction, chainId: id);
  return result;
}
