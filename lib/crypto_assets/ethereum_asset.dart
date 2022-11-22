// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../api_service/api_services.dart';
import '../wallet_config.dart';
import '../components/base_tokens_container.dart';
import '../constants.dart';
import '../models/walletModel.dart';
import '../utils/utils.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:http/http.dart';

class EthereumAsset extends StatefulWidget {
  const EthereumAsset({Key? key}) : super(key: key);

  @override
  State<EthereumAsset> createState() => _EthereumAssetState();
  static var isMainnet = Hive.box('wallets').get('isMainNet');
  static final Client httpClient = Client();
  static web3.Web3Client ethClient = (isMainnet)
      ? web3.Web3Client(
          "https://mainnet.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
          httpClient)
      : web3.Web3Client(
          "https://rinkeby.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
          httpClient);

  Future<double> ethBalance() async {
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final web3.Web3Client _ethClient = (isMainnet)
        ? web3.Web3Client(
            "https://mainnet.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
            httpClient)
        : web3.Web3Client(
            "https://rinkeby.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
            httpClient);
    final UserWalletsModel walletsModel = WalletConfig().getWallet();
    final bal = await ethAddressBalance(walletsModel.ethAddress, _ethClient);
    return bal;
  }

  Future<String> sendEthButton(double enteredAmt, String recAddress) async {
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final Client httpClient = Client();
    final int chainId = (isMainnet) ? 1 : 4;
    final web3.Web3Client _ethClient = (isMainnet)
        ? web3.Web3Client(
            "https://mainnet.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
            httpClient)
        : web3.Web3Client(
            "https://rinkeby.infura.io/v3/5cf2749b881547e3b8858a72ad9ae159",
            httpClient);
    try {
      final sendAmt = toEtherAmt(enteredAmt);
      var response =
          await sendEthToken(recAddress, sendAmt, _ethClient, chainId);
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

class _EthereumAssetState extends State<EthereumAsset> {
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
  final String _assetLogo = 'assets/svg_icon/etherium.svg';
  final String _assetSymbol = 'ETH';
  double? _ethBalValueUsd;
  double? _ethBalance;
  double? _priceChange;
  bool _isReLoading = false;
  double? _ethPrice;

  Future _fetchAssetDetails() async {
    setState(() {
      _isReLoading = true;
    });
    final marketData = (await ApiServices().getCoinMarketData('ethereum'))!;
    final priceChange = marketData.priceChangePercentage24H;
    _priceChange = double.parse(truncateUSD(priceChange));
    _ethPrice = marketData.currentPrice;
    _ethBalance = await const EthereumAsset().ethBalance();
    _ethBalValueUsd = _ethPrice! * _ethBalance!;
    WalletConfig().addTotalBalUsd(_ethBalValueUsd!, 1);
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
      name: 'ETHEREUM',
      balance:
          (_isLoading) ? 'null' : '${_ethBalance.toString()} $_assetSymbol',
      logoAsset: _assetLogo,
      tokenNameShort: _assetSymbol,
      isReLoading: _isReLoading,
      tokenValueUsd: (_isLoading) ? '' : truncateUSD(_ethBalValueUsd!),
      priceChange24h: _priceChange ?? 0.00,
      tokenPrice: _ethPrice ?? 0.00,
    );
  }
}
