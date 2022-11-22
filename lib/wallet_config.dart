import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/crypto_assets/bitcoin_asset.dart';
import 'package:my_crypto_wallet/crypto_assets/ethereum_asset.dart';
import 'components/modal_box.dart';
import 'crypto_assets/bianance_asset.dart';
import 'models/transfer_data_model.dart';
import 'models/walletModel.dart';
import 'package:get/state_manager.dart';

class WalletConfig extends ChangeNotifier {
  static RxList tokenValueUsdList = [].obs;
  static double? totalBalUsd;
  static String token = "?token=36d962766a20451aa3f7af17d5b03d93";
  static String mainetUrl = 'https://api.blockcypher.com/v1/btc/main/addrs/';
  static String testnetUrl = 'https://api.blockcypher.com/v1/btc/test3/addrs/';
  static String tatumBitcoinApi =
      "https://api-eu1.tatum.io/v3/bitcoin/transaction";
  static String geckoPriceLink =
      'https://api.coingecko.com/api/v3/simple/price?ids=';
  static String geckoCoinMarketDataLink =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=";
  static String marketDataLinkExtension =
      "&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  Future<void> init(BuildContext context) async {}

  UserWalletsModel getWallet() {
    final activeWalletId = Hive.box('wallets').get('activeWallet');
    final UserWalletsModel _activeWallet =
        Hive.box('wallets').get(activeWalletId);
    return _activeWallet;
  }

  showModalBox(BuildContext context, Widget buildWidget) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x88000000),
      context: context,
      builder: (context) {
        return ModalBox(
          refresh: () {},
          modalWidget: buildWidget,
        );
      },
    );
  }

  addTotalBalUsd(double value, int index) {
    if (tokenValueUsdList.isEmpty) {
      tokenValueUsdList.add(value);
    } else if (tokenValueUsdList.length == 1) {
      tokenValueUsdList.add(value);
    } else if (tokenValueUsdList.length == 2) {
      tokenValueUsdList.add(value);
    } else {
      tokenValueUsdList[index] = value;
    }
  }

  Future<List<TransferData>> getAssetList() async {
    final UserWalletsModel walletData = WalletConfig().getWallet();
    final bool isMainnet = Hive.box('wallets').get('isMainNet');
    final List<TransferData> assetList = [
      TransferData(
          logoAsset: 'assets/svg_icon/bitcoin.svg',
          address: (isMainnet)
              ? walletData.bitcoinAddress
              : walletData.bitTestAddress,
          tokenBalance: () async {
            final bal = await const BitcoinAsset().btcBalance();
            return bal;
          },
          sendMethod: (enteredAmt, receiver) async {
            final res =
                await const BitcoinAsset().btcSendButton(receiver, enteredAmt);
            return res;
          },
          tokenNameShort: 'BTC',
          tokenName: 'Bitcoin',
          tokenNameGecko: 'bitcoin',
          chain: 'btc'),
      TransferData(
          client: EthereumAsset.ethClient,
          logoAsset: 'assets/svg_icon/etherium.svg',
          address: walletData.ethAddress,
          tokenBalance: () async {
            final bal = await const EthereumAsset().ethBalance();
            return bal;
          },
          sendMethod: (enteredAmt, receiver) async {
            final res =
                await const EthereumAsset().sendEthButton(enteredAmt, receiver);
            return res;
          },
          tokenNameShort: 'ETH',
          tokenName: 'Ethereum',
          tokenNameGecko: 'ethereum',
          chain: 'eth'),
      TransferData(
          client: BinanceAsset.bnbClient,
          logoAsset: 'assets/svg_icon/binance.svg',
          address: walletData.ethAddress,
          tokenBalance: () async {
            final bal = await const BinanceAsset().bnbBalance();
            return bal;
          },
          sendMethod: (enteredAmt, receiver) async {
            final res =
                await const BinanceAsset().sendBNBButton(enteredAmt, receiver);
            return res;
          },
          tokenNameShort: 'BNB',
          tokenName: 'Binance',
          tokenNameGecko: 'binancecoin',
          chain: 'eth'),
    ];
    return assetList;
  }
}
