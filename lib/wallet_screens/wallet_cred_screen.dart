import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants.dart';
import '../custom_widgets/appbar_widget.dart';
import '../custom_widgets/seedphrase_widget.dart';
import '../models/walletModel.dart';

class WalletSecretData extends StatefulWidget {
  const WalletSecretData({Key? key}) : super(key: key);

  @override
  State<WalletSecretData> createState() => _WalletSecretDataState();
}

class _WalletSecretDataState extends State<WalletSecretData> {
  String? _seedPhrase;

  @override
  void initState() {
    _fetchUserWallet();
    super.initState();
  }

  Future _fetchUserWallet() async {
    final activeWalletId = Hive.box('wallets').get('activeWallet');
    if (activeWalletId == '') {
    } else {
      final UserWalletsModel activeWallet =
          Hive.box('wallets').get(activeWalletId);
      setState(() {
        _seedPhrase = activeWallet.mnemonic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: kTextColorDark,
        backgroundColor: kDefaultThemeColor,
        title: const AppBarWidget(
          title: 'Wallet Recovery Data',
          showNetwork: false,
        ),
      ),
      body: SafeArea(
        child: SeedPhraseWidget(seedPhrase: _seedPhrase),
      ),
    );
  }
}
