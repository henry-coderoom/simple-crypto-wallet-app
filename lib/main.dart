// @dart=2.9

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:my_crypto_wallet/models/walletModel.dart';
import 'package:my_crypto_wallet/wallet_screens/wallet_view.dart';
import 'package:my_crypto_wallet/wallet_screens/welcom_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(UserWalletsModelAdapter());
  final _walletsBox = await Hive.openBox('wallets');
  await Hive.openBox('refresh');
  if (Hive.box('wallets').isEmpty) {
    await _walletsBox.put('activeWallet', '');
    await _walletsBox.put('isMainNet', true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isWalletAvail;

  Future _checkAvailWallet() async {
    final activeWalletId = Hive.box('wallets').get('activeWallet');
    if (activeWalletId == '') {
      setState(() {
        _isWalletAvail = false;
      });
    } else {
      setState(() {
        _isWalletAvail = true;
      });
    }
  }

  @override
  void initState() {
    Hive.box('wallets').watch().listen((event) {
      if (event.key == 'activeWallet') {
        final box = Hive.box('wallets');
        if (box.values.length >= 3) {
          _checkAvailWallet();
        }
      }
    });
    _checkAvailWallet();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WalletConfig().init(context);
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Crypto App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: (_isWalletAvail)
            ? WalletView(updateWalletScreen: () => _checkAvailWallet())
            : const WelcomeScreen(),
      ),
    );
  }
}
