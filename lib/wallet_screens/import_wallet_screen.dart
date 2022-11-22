// ignore_for_file: file_names
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/components/custom_text_form.dart';
import 'package:my_crypto_wallet/components/default_button.dart';
import 'package:my_crypto_wallet/custom_widgets/policy_widget.dart';
import 'package:my_crypto_wallet/utils/generate_wallet_methods.dart';
import 'package:my_crypto_wallet/utils/utils.dart';
import '../constants.dart';
import '../custom_widgets/appbar_widget.dart';
import '../custom_widgets/form_buttons_widget.dart';
import '../utils/keyboard.dart';

class ImportWallet extends StatefulWidget {
  final Function() refreshWallet;
  final Function() popCreateScreen;

  const ImportWallet(
      {Key? key, required this.refreshWallet, required this.popCreateScreen})
      : super(key: key);
  static String routeName = '/importWallet';

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  final TextEditingController _seedPhraseController = TextEditingController();
  bool _switchValue = false;
  bool _isNotValid = false;
  bool _isPhraseEmpty = false;
  final List<String?> errors = [];

  @override
  void initState() {
    super.initState();
  }

  FocusNode textSecondFocusNode = FocusNode();

  navigateWallet() async {
    Navigator.pop(context);
    widget.refreshWallet();
  }

  _resetIsNotValid() {
    setState(() {
      _isNotValid = false;
    });
  }

  Future _doImport() async {
    GenerateWallet service = GenerateWallet();
    final mnemonic = _seedPhraseController.text.trim();
    await service.doExtractWallet(mnemonic);
    setState(() {
      _switchValue = false;
      _seedPhraseController.text = '';
    });
    showToastOne(context, "Success!", Icons.check_circle, 1);
    await Future.delayed(const Duration(milliseconds: 100));
    navigateWallet();
  }

  @override
  void dispose() {
    _seedPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: kTextColorDark,
        backgroundColor: kDefaultThemeColor,
        title: const AppBarWidget(
          title: 'Import wallet',
          showNetwork: false,
        ),
      ),
      body: SingleChildScrollView(
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
            )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: buildSeedPhraseTextField(),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: (_isPhraseEmpty)
                  ? buildEmptyPhraseWidget()
                  : (_isNotValid == true)
                      ? buildInvalidPhraseWidget()
                      : const SizedBox.shrink(),
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultButton(
              onTap: (_seedPhraseController.text.isEmpty)
                  ? () {
                      setState(() {
                        FocusScope.of(context)
                            .requestFocus(textSecondFocusNode);
                        _isPhraseEmpty = true;
                      });
                    }
                  : () async {
                      KeyboardUtil.hideKeyboard(context);
                      if (bip39.validateMnemonic(
                              _seedPhraseController.text.trim()) ==
                          true) {
                        setState(() {
                          _isNotValid = false;
                        });
                        try {
                          if (_switchValue == true) {
                            await Future.delayed(
                                const Duration(milliseconds: 1000));
                            await _doImport();
                          } else {
                            showToastOne(
                                context,
                                'Consent to the term before proceeding.',
                                Icons.error_outline,
                                3);
                          }
                        } catch (e) {
                          showBetterSnackBar(context, e.toString(), 4, () {},
                              '', Icons.error_outline, kTextColorLight);
                        }
                      } else {
                        setState(() {
                          _isNotValid = true;
                        });
                      }
                    },
              padding: 45,
              radius: 25,
              withIcon: true,
              textColor: kTextColorWhite,
              bgColor: kDefaultThemeDarkerColor,
              borderColor: Colors.transparent,
              buttonText: 'Import',
              icon: Icons.file_download_outlined,
            ),
            DefaultButton(
              onTap: () {
                navigateWallet();
              },
              padding: 0,
              radius: 0,
              withIcon: true,
              textColor: Colors.blue,
              bgColor: Colors.transparent,
              borderColor: Colors.transparent,
              buttonText: 'Go back',
              icon: Icons.arrow_back_sharp,
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Container buildEmptyPhraseWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(primary: Colors.transparent, elevation: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(
              height: 12,
            ),
            Text(
              'Seed phrase is required to import wallet!',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Divider(
              color: kBackgroundLight,
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  Container buildInvalidPhraseWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(primary: kBackgroundLight, elevation: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Text(
                'Invalid seed phrase, please make sure;',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isNotValid = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Typicons.cancel_circled_outline,
                      color: kTextColorLight,
                      size: 18,
                    ),
                  )),
            ),
            const Divider(
              color: kTextColorDarkest,
            ),
            const Text(
              kInvalidSeedPhrase,
              style: TextStyle(color: kTextColorDarkest),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  CustomTextForm buildSeedPhraseTextField() {
    return CustomTextForm(
      focusNode: textSecondFocusNode,
      controller: _seedPhraseController,
      hasSuffix: true,
      hinText: "enter your mnemonic/recovery seed phrase...",
      textInputType: TextInputType.multiline,
      onChanged: (text) {
        _resetIsNotValid();
        if (text.isNotEmpty) {
          setState(() {
            _isPhraseEmpty = false;
          });
        }
      },
      suffixWidget: FormButtonWidget(
        action1: () {
          Clipboard.getData(Clipboard.kTextPlain).then((value) async {
            _resetIsNotValid();
            setState(() {
              _seedPhraseController.text = (value?.text)!;
            });
          });
        },
        action2: (text) {
          _resetIsNotValid();
          setState(() {
            _seedPhraseController.text = text;
          });
        },
      ),
    );
  }
}
