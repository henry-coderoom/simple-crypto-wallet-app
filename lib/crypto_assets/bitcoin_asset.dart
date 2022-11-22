// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:my_crypto_wallet/wallet_config.dart';
import '../api_service/api_services.dart';
import '../components/base_tokens_container.dart';
import '../models/tx_hash_model.dart';
import '../models/walletModel.dart';
import '../utils/utils.dart';

class BitcoinAsset extends StatefulWidget {
  const BitcoinAsset({Key? key}) : super(key: key);

  @override
  State<BitcoinAsset> createState() => _BitcoinAssetState();

  Future<double> btcBalance() async {
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final bitAddrInfo = (isMainnet)
        ? (await ApiServices().getWalletDataMain())!
        : (await ApiServices().getWalletDataTest())!;
    final satoshiBalance = bitAddrInfo.balance;
    final double btcBalance =
        double.parse(truncate(satoshiBalance / 100000000)!);
    return btcBalance;
  }

  Future<String> btcSendButton(String recAddress, double enteredAmt) async {
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final UserWalletsModel _activeWallet = WalletConfig().getWallet();
    final balance = await btcBalance();
    const double txFee = 0.00004;
    final double change = balance - txFee - enteredAmt;
    final double changeShort = double.parse(truncateAmt(change)!);
    final String address = (isMainnet)
        ? _activeWallet.bitcoinAddress
        : _activeWallet.bitTestAddress;
    final String privKey =
        (isMainnet) ? _activeWallet.bitAddressWif : _activeWallet.bitTestWif;
    try {
      var url = Uri.parse(WalletConfig.tatumBitcoinApi);
      var response = await http.post(url,
          headers: {
            'x-api-key': (isMainnet)
                ? 'e6342f5a-a4bd-473a-a214-244e74f258a8'
                : 'ea490e16-de50-4a5f-9001-556a2c8829cc',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "fromAddress": [
              {"address": address, "privateKey": privKey}
            ],
            "to": [
              {"address": recAddress, "value": enteredAmt},
              {"address": address, "value": changeShort}
            ]
          }));
      if (response.statusCode == 200) {
        TxHashModel txHashModel = txHashModelFromJson(response.body);
        final String res = txHashModel.txId;
        return res;
      } else {
        final res = response.body;
        print(res);
      }
      return '';
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
      return '';
    }
  }
}

class _BitcoinAssetState extends State<BitcoinAsset> {
  @override
  void initState() {
    Hive.box('wallets').watch().listen((_) {
      final box = Hive.box('wallets');
      if (box.values.length > 2) {
        _fetchAssetDetails();
      }
    });
    Hive.box('refresh').watch().listen((_) {
      _fetchAssetDetails();
    });

    _fetchAssetDetails();
    super.initState();
  }

  bool _isLoading = true;
  final String _assetLogo = 'assets/svg_icon/bitcoin.svg';
  final String _assetSymbol = 'BTC';
  double? _btcBalValueUsd;
  double? _priceChange;
  var _btcBalance;
  bool _isReLoading = false;
  var _btcPrice;

  Future _fetchAssetDetails() async {
    setState(() {
      _isReLoading = true;
    });
    final marketData = (await ApiServices().getCoinMarketData('bitcoin'))!;
    final priceChange = marketData.priceChangePercentage24H;
    _priceChange = double.parse(truncateUSD(priceChange));
    _btcPrice = marketData.currentPrice;

    _btcBalance = await const BitcoinAsset().btcBalance();
    _btcBalValueUsd = _btcPrice! * _btcBalance;

    WalletConfig().addTotalBalUsd(_btcBalValueUsd!, 0);

    setState(() {
      _isReLoading = false;
      _isLoading = false;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTokensContainer(
      name: 'BITCOIN',
      balance:
          (_isLoading) ? 'null' : '${_btcBalance.toString()} $_assetSymbol',
      logoAsset: _assetLogo,
      tokenNameShort: _assetSymbol,
      isReLoading: _isReLoading,
      tokenValueUsd: (_isLoading) ? '' : truncateUSD(_btcBalValueUsd!),
      priceChange24h: _priceChange ?? 0.00,
      tokenPrice: _btcPrice ?? 0.00,
    );
  }
}
