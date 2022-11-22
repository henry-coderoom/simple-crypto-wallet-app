// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/api_service/api_services.dart';
import '../wallet_config.dart';
import '../components/base_tokens_container.dart';
import '../constants.dart';
import '../models/walletModel.dart';
import '../utils/utils.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:http/http.dart';

class BinanceAsset extends StatefulWidget {
  const BinanceAsset({Key? key}) : super(key: key);

  @override
  State<BinanceAsset> createState() => _BinanceAssetState();
  static var isMainnet = Hive.box('wallets').get('isMainNet');
  static final Client httpClient = Client();
  static web3.Web3Client bnbClient = (isMainnet)
      ? web3.Web3Client("https://bsc-dataseed1.binance.org:443", httpClient)
      : web3.Web3Client(
          "https://data-seed-prebsc-1-s2.binance.org:8545", httpClient);

  Future<double> bnbBalance() async {
    final UserWalletsModel walletsModel = WalletConfig().getWallet();
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final web3.Web3Client _bnbClient = (isMainnet)
        ? web3.Web3Client("https://bsc-dataseed1.binance.org:443", httpClient)
        : web3.Web3Client(
            "https://data-seed-prebsc-1-s2.binance.org:8545", httpClient);
    final bal = await ethAddressBalance(walletsModel.ethAddress, _bnbClient);
    return bal;
  }

  Future<String> sendBNBButton(double enteredAmt, String recAddress) async {
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final int chainId = (isMainnet) ? 56 : 97;
    final web3.Web3Client _bnbClient = (isMainnet)
        ? web3.Web3Client("https://bsc-dataseed1.binance.org:443", httpClient)
        : web3.Web3Client(
            "https://data-seed-prebsc-1-s2.binance.org:8545", httpClient);
    try {
      final sendAmt = toEtherAmt(enteredAmt);
      var response =
          await sendEthToken(recAddress, sendAmt, _bnbClient, chainId);
      if (kDebugMode) {
        print(response);
      }
      return response;
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
      if (err.toString() == kEtherInsufficientFunds) {
        return 'low_bal';
      }
      return '';
    }
  }
}

class _BinanceAssetState extends State<BinanceAsset> {
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
  final String _assetLogo = 'assets/svg_icon/binance.svg';
  final String _assetSymbol = 'BNB';
  double? _priceChange;
  var _bnbBalValueUsd;
  double? _bnbBalance;
  bool _isReLoading = false;
  double? _bnbPrice;

  Future _fetchAssetDetails() async {
    setState(() {
      _isReLoading = true;
    });
    final marketData = (await ApiServices().getCoinMarketData('binancecoin'))!;
    final priceChange = marketData.priceChangePercentage24H;
    _priceChange = double.parse(truncateUSD(priceChange));
    _bnbPrice = marketData.currentPrice;

    _bnbBalance = await const BinanceAsset().bnbBalance();
    _bnbBalValueUsd = _bnbPrice! * _bnbBalance!;
    WalletConfig().addTotalBalUsd(_bnbBalValueUsd, 2);
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
      name: 'BINANCE',
      balance:
          (_isLoading) ? 'null' : '${_bnbBalance.toString()} $_assetSymbol',
      logoAsset: _assetLogo,
      tokenNameShort: _assetSymbol,
      isReLoading: _isReLoading,
      tokenValueUsd: (_isLoading) ? '' : truncateUSD(_bnbBalValueUsd!),
      priceChange24h: _priceChange ?? 0.00,
      tokenPrice: _bnbPrice ?? 0.00,
    );
  }
}
