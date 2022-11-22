import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_crypto_wallet/components/default_button.dart';
import 'package:my_crypto_wallet/constants.dart';
import 'package:my_crypto_wallet/models/walletModel.dart';
import 'package:my_crypto_wallet/utils/utils.dart';

import '../wallet_screens/create_wallet.dart';
import '../wallet_screens/import_wallet_screen.dart';

class SwitchWallet extends StatefulWidget {
  const SwitchWallet({
    Key? key,
  }) : super(key: key);

  @override
  State<SwitchWallet> createState() => _SwitchWalletState();
}

class _SwitchWalletState extends State<SwitchWallet> {
  String _activeWalletId = Hive.box('wallets').get('activeWallet');

  _deleteWallet(Box box, int index) async {
    final currentBox = box;
    final UserWalletsModel walletData = currentBox.getAt(index);
    if (walletData.ethAddress.toString() == _activeWalletId) {
      if (box.values.length >= 4) {
        await currentBox.deleteAt(index);
        final UserWalletsModel wallets = currentBox.getAt(0);
        _updateActiveWallet(wallets.ethAddress.toString());
        Navigator.pop(context);
      } else {
        _updateActiveWallet('');
        await currentBox.deleteAt(index);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      await currentBox.deleteAt(index);
      Navigator.pop(context);
    }
  }

  Future _updateActiveWallet(
    String pubAddress,
  ) async {
    final box = Hive.box('wallets');
    await box.put('activeWallet', pubAddress);
    setState(() {
      _activeWalletId = Hive.box('wallets').get('activeWallet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
          child: Text(
            'Choose Wallet',
            style: TextStyle(
                color: kTextColorDarkest,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box('wallets').listenable(),
          builder: (context, Box _box, widget) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _box.values.length - 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(
                          child: (_box.keyAt(index) == 'activeWallet' ||
                                  _box.keyAt(index) == 'isMainNet')
                              ? const SizedBox.shrink()
                              : buildWalletListWidget(context, _box, index)),
                    ],
                  ),
                );
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDefaultButton(
                  context, 'Create new wallet', const CreateWallet()),
              const SizedBox(
                width: 15,
              ),
              buildDefaultButton(
                  context,
                  'Import new wallet',
                  ImportWallet(
                    popCreateScreen: () => null,
                    refreshWallet: () => null,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  DefaultButton buildDefaultButton(
      BuildContext context, String buttonText, Widget screen) {
    return DefaultButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
              ));
        },
        padding: 3,
        radius: 25,
        withIcon: false,
        textColor: Colors.blue,
        bgColor: Colors.transparent,
        borderColor: Colors.blue,
        buttonText: buttonText);
  }

  Row buildWalletListWidget(BuildContext context, Box _box, int index) {
    Box currentBox = _box;
    final UserWalletsModel walletData = currentBox.getAt(index);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            _updateActiveWallet(walletData.ethAddress.toString());
            Navigator.pop(context);
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text('Wallet - ${walletData.walletId}',
                      style: const TextStyle(
                          color: kTextColorDarkest,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                  SizedBox(
                    child: (walletData.ethAddress.toString() == _activeWalletId)
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                border:
                                    Border.all(color: Colors.green, width: 1)),
                            margin: const EdgeInsets.only(left: 5),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: const Text(
                              'active',
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
            Text(
              walletData.ethAddress,
              style: const TextStyle(
                  color: kTextColorLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        IconButton(
            onPressed: () async {
              simpleAlert(
                  context, buildDeleteAlertWidget(context, _box, index));
            },
            icon: Icon(
              Icons.delete,
              size: 18,
              color: Colors.red.shade900,
            )),
      ],
    );
  }

  Stack buildDeleteAlertWidget(BuildContext context, Box box, int index) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 8),
                child: Text(
                  'Remove this wallet?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kTextColorDarkest),
                ),
              ),
              const Text(
                'Before you proceed, make sure you have correctly backed up the seed phrase for this wallet to avoid loss of funds.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kTextColorDark),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DefaultButton(
                        onTap: () => Navigator.pop(context),
                        padding: 15,
                        radius: 25,
                        withIcon: false,
                        textColor: kTextColorDarkest,
                        bgColor: kDefaultThemeColor,
                        borderColor: Colors.transparent,
                        buttonText: 'Cancel'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DefaultButton(
                        onTap: () => _deleteWallet(box, index),
                        padding: 13,
                        radius: 25,
                        withIcon: false,
                        textColor: kTextColorDarkest,
                        bgColor: kDefaultThemeColor,
                        borderColor: Colors.transparent,
                        buttonText: 'Proceed'),
                  )
                ],
              )
            ],
          ),
          Positioned(
              top: -45,
              child: CircleAvatar(
                backgroundColor: kBackgroundWhite,
                radius: 35,
                child: Icon(
                  Icons.error_outlined,
                  color: Colors.deepOrangeAccent.shade200,
                  size: 70,
                ),
              ))
        ]);
  }
}
