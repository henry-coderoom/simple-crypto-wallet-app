import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/size_config.dart';

const kBackgroundLight = Color(0xFFE8E8E8); //The same for light and dark theme
const kBackgroundWhite = Colors.white;
const kTextColorWhite = Colors.white;
const kTextColorLight = Colors.grey;
const kTextColorDark = Colors.black45;
const kTextColorDarkest = Colors.black87;
final kDefaultThemeColor = Colors.teal.shade100;
final kDefaultThemeDarkerColor = Colors.teal.shade300;
final kDefaultThemeDarkestColor = Colors.teal.shade900;

const kFormTextStyle =
    TextStyle(fontWeight: FontWeight.w500, color: kTextColorDarkest);

const kAppBarTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

const String kBackupSeedPhraseText =
    'I have saved or backed-up my Private Key and Recovery Phrase for the current wallet address so I can import it later';
const String kNameNullError = 'Please enter a name for this wallet.';
const String kInvalidWalletName =
    'Only \'_\' and \'#\' are allowed in Wallet name field.';
const String kWalletNameExist = 'Wallet name already exists.';
const String kShortPasswordText = 'Password should be 6 characters or more.';
const String kPolicyText =
    'By continuing, you agree to our privacy policy and terms of service.';
const String kInvalidSeedPhrase =
    'The words are separated by single space \nThe words are in the correct order \nThe words are all in lowercase and spelled correctly \nThe words are exactly 12 or 24 in number';
const String kEtherInsufficientFunds =
    'RPCError: got code -32000 with msg "insufficient funds for gas * price + value".';
const String kTxFailedText = '';
const String kWalletCreatedText =
    'New wallet created successfully! Don\'t forget to save your seed phrase in order to be able access the wallet anywhere.';

final kDefaultBorderDeco = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: Color(0xFFffffff), width: 1.0),
);

final kDefaultErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: Colors.red, width: 1.0),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColorLight),
  );
}
