// ignore_for_file: file_names

import 'dart:math';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/components/center_loader.dart';
import 'package:my_crypto_wallet/components/default_button.dart';
import 'package:my_crypto_wallet/constants.dart';
import 'package:my_crypto_wallet/custom_widgets/seedphrase_widget.dart';
import 'package:my_crypto_wallet/utils/generate_wallet_methods.dart';
import 'package:my_crypto_wallet/utils/utils.dart';
import 'package:my_crypto_wallet/models/walletModel.dart';
import 'package:my_crypto_wallet/wallet_config.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/appbar_widget.dart';
import '../custom_widgets/simple_modal_widget.dart';
import '../custom_widgets/policy_widget.dart';
import 'import_wallet_screen.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({
    Key? key,
  }) : super(key: key);
  static String routeName = '/createWallet';

  @override
  State<CreateWallet> createState() => _CreateWallet();
}

class _CreateWallet extends State<CreateWallet> {
  String? _userPhrase;
  bool? isCreated;
  bool _isNewCreated = false;
  bool _switchValue = false;
  bool _fetchInitData = true;
  bool _revealPhrase = true;

  @override
  void initState() {
    _fetchUserWallet();
    super.initState();
  }

  Future _fetchUserWallet() async {
    await Hive.openBox('wallets');
    final activeWalletId = Hive.box('wallets').get('activeWallet');
    if (activeWalletId == '') {
      setState(() {
        _fetchInitData = false;
      });
    } else {
      final UserWalletsModel activeWallet =
          Hive.box('wallets').get(activeWalletId);
      setState(() {
        _userPhrase = activeWallet.mnemonic;

        _fetchInitData = false;
      });
    }
  }

  _doCreateWallet() async {
    GenerateWallet service = GenerateWallet();
    await service.doExtractWallet('');
    await _fetchUserWallet();
    WalletConfig().showModalBox(context, const SimpleModalWidget());
    setState(() {
      _switchValue = false;
      _isNewCreated = true;
    });
  }

  navigate() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: kTextColorDark,
        backgroundColor: kDefaultThemeColor,
        title: const AppBarWidget(
          title: 'Create New Wallet',
          showNetwork: false,
        ),
      ),
      body: (_fetchInitData)
          ? const CenterLoading(loadingText: '')
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  PolicyWidget(
                    switchWidget: Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  DefaultButton(
                    onTap: () async {
                      try {
                        if (_switchValue == true) {
                          await Future.delayed(
                              const Duration(milliseconds: 1500));
                          _doCreateWallet();
                        } else {
                          showToastOne(
                              context,
                              'Consent to the term before proceeding.',
                              Icons.error_outline,
                              3);
                        }
                      } catch (err) {
                        showBetterSnackBar(context, e.toString(), 4, () {}, '',
                            Icons.error_outline, kTextColorLight);
                      }
                    },
                    padding: 8,
                    radius: 25,
                    withIcon: true,
                    textColor: kTextColorWhite,
                    bgColor: kDefaultThemeDarkerColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Create new wallet',
                    icon: Icons.add,
                  ),
                  DefaultButton(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportWallet(
                              refreshWallet: () {
                                navigate();
                              },
                              popCreateScreen: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ));
                    },
                    padding: 0,
                    radius: 0,
                    withIcon: true,
                    textColor: Colors.blue,
                    bgColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    buttonText: 'Import wallet',
                    icon: Icons.file_download_outlined,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: (_isNewCreated)
                        ? [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'New Wallet Details',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kTextColorDarkest),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    child: (_revealPhrase)
                                        ? Row(
                                            children: const [
                                              Text(
                                                'Hide',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.visibility_off_outlined,
                                                color: Colors.blue,
                                                size: 16,
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: const [
                                              Text(
                                                'Show',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.visibility_outlined,
                                                color: Colors.blue,
                                                size: 16,
                                              )
                                            ],
                                          ),
                                  ),
                                  onTap: (_revealPhrase)
                                      ? () {
                                          setState(() {
                                            _revealPhrase = false;
                                          });
                                        }
                                      : () {
                                          setState(() {
                                            _revealPhrase = true;
                                          });
                                        },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: (_revealPhrase)
                                  ? SeedPhraseWidget(seedPhrase: _userPhrase)
                                  : const SizedBox.shrink(),
                            ),
                            Center(
                                child: DefaultButton(
                              onTap: () {
                                navigate();
                              },
                              padding: 0,
                              radius: 0,
                              withIcon: true,
                              textColor: Colors.blue,
                              bgColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              buttonText: 'Back to wallet',
                              icon: Icons.arrow_back_sharp,
                            )),
                            const SizedBox(
                              height: 20,
                            )
                          ]
                        : [const SizedBox.shrink()],
                  )
                ],
              ),
            ),
    );
  }
}
