// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:my_crypto_wallet/components/center_loader.dart';
import 'package:my_crypto_wallet/crypto_assets/bianance_asset.dart';
import 'package:my_crypto_wallet/crypto_assets/bitcoin_asset.dart';
import 'package:my_crypto_wallet/crypto_assets/ethereum_asset.dart';
import 'package:my_crypto_wallet/wallet_screens/wallet_cred_screen.dart';
import '../components/custom_toggle.dart';
import '../components/total_balance_container.dart';
import '../constants.dart';
import '../models/walletModel.dart';

class WalletView extends StatefulWidget {
  final Function() updateWalletScreen;
  const WalletView({Key? key, required this.updateWalletScreen})
      : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with AutomaticKeepAliveClientMixin<WalletView> {
  bool _isReLoading = false;
  String? _walletId;
  bool _isLoading = true;
  double _totalBalanceUsd = 0.00;
  List<Widget> _assets = [];
  @override
  void initState() {
    Hive.openBox('wallets');
    _fetchUserAssets();
    Hive.box('wallets').watch().listen((event) {
      final box = Hive.box('wallets');
      if (box.values.length == 2) {
        widget.updateWalletScreen();
      } else {
        _fetchUserAssets();
      }
    });
    WalletConfig.tokenValueUsdList.listen((value) {
      if (value.isNotEmpty) {
        setState(() {
          _totalBalanceUsd = value.reduce((a, b) => a + b);
        });
      }
    });
    super.initState();
  }

  Future _refreshWallet() async {
    final box = Hive.box('refresh');
    await box.put('update', Random().nextInt(100));
    await _fetchUserAssets();
  }

  Future _fetchUserAssets() async {
    final UserWalletsModel activeWalletData = WalletConfig().getWallet();
    setState(() {
      _assets = [
        const BitcoinAsset(),
        const EthereumAsset(),
        const BinanceAsset()
      ];
      _isReLoading = true;
      _walletId = activeWalletData.walletId.toString();
      _isLoading = false;
      _isReLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kDefaultThemeColor,
        title: AnimatedToggle(
          values: const ['MAINNET', 'TESTNET'],
          onToggleCallback: (value) async {
            final box = await Hive.openBox('wallets');
            await box.put('isMainNet', value);
          },
          buttonColor: kDefaultThemeColor,
          textColor: kTextColorDarkest,
        ),
      ),
      body: SafeArea(
        child: (_isLoading)
            ? const CenterLoading(
                loadingText: 'Fetching current wallet...',
              )
            : RefreshIndicator(
                onRefresh: () async {
                  _refreshWallet();
                  await Future.delayed(const Duration(milliseconds: 1500));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      TotalBalanceContainer(
                        walletId: _walletId!,
                        totalBal: _totalBalanceUsd,
                        isReloading: _isReLoading,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _assets.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _assets[index];
                          }),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20, bottom: 50, right: 30),
                        alignment: Alignment.bottomRight,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WalletSecretData(),
                                  ));
                            },
                            child: const Text('See Wallet Recovery Data'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
