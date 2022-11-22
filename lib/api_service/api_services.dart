// import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_crypto_wallet/models/bitcoin_data_model.dart';
import 'package:my_crypto_wallet/models/coin_market_data_model.dart';
import '../models/price_data_model.dart';
import '../models/walletModel.dart';
import '../wallet_config.dart';

class ApiServices {
  final UserWalletsModel _activeWallet = WalletConfig().getWallet();

  Future<CoinMarketDataModel?>? getCoinMarketData(String tokenName) async {
    try {
      var url = Uri.parse(WalletConfig.geckoCoinMarketDataLink +
          tokenName +
          WalletConfig.marketDataLinkExtension);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        CoinMarketDataModel _model =
            coinMarketDataModelFromJson(response.body)[0];

        return _model;
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<BitcoinAddressData?>? getWalletDataMain() async {
    try {
      var url = Uri.parse(WalletConfig.mainetUrl +
          _activeWallet.bitcoinAddress +
          WalletConfig.token);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        BitcoinAddressData _model = bitcoinAddressDataFromJson(response.body);

        return _model;
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<BitcoinAddressData?>? getWalletDataTest() async {
    try {
      var url = Uri.parse(WalletConfig.testnetUrl +
          _activeWallet.bitTestAddress +
          WalletConfig.token);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        BitcoinAddressData _model = bitcoinAddressDataFromJson(response.body);
        return _model;
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<List<Txref>> getUtxoHashMain() async {
    try {
      var url = Uri.parse(WalletConfig.mainetUrl +
          _activeWallet.bitcoinAddress +
          '?unspentOnly=true' +
          WalletConfig.token);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        BitcoinAddressData bitData = bitcoinAddressDataFromJson(response.body);
        List<Txref> _utxo = bitData.txrefs;
        if (_utxo.isEmpty) {
          return [];
        }
        return _utxo;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<List<Txref>> getUtxoHashTest() async {
    try {
      var url = Uri.parse(WalletConfig.testnetUrl +
          _activeWallet.bitTestAddress +
          '?unspentOnly=true');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        BitcoinAddressData bitData = bitcoinAddressDataFromJson(response.body);
        List<Txref> _utxo = bitData.txrefs;
        if (_utxo.isEmpty) {
          return [];
        }
        return _utxo;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<CoinPriceData?> getCoinPriceData(String coin) async {
    try {
      var url =
          Uri.parse(WalletConfig.geckoPriceLink + coin + '&vs_currencies=usd');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        CoinPriceData _priceData = coinPriceDataFromJson(response.body, coin);
        return _priceData;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
