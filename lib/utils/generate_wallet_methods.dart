import 'dart:math';
import 'package:hive/hive.dart';
import 'package:my_crypto_wallet/utils/wallet_creation.dart';
import '../models/walletModel.dart';

class GenerateWallet {
  Future doExtractWallet(String seedPhrase) async {
    WalletAddress service = WalletAddress();
    final mnemonic =
        (seedPhrase != '') ? seedPhrase : service.generateMnemonic();
    final ethPrivateKey = await service.getPrivateKey(mnemonic);
    final bitNodeTest = await service.getBitcoinTestNode(mnemonic);
    final bitNodeMain = await service.getBitcoinNode(mnemonic);
    final ethPublicAddress = await service.getPublicKey(ethPrivateKey);
    final String ethPrivKey = ethPrivateKey.toString();
    final String ethAddress = ethPublicAddress.toString();
    final bitcoinAddress = await service.getBitcoinAddress(bitNodeMain);
    final bitcoinPubKey = await service.getBitcoinPubKey(bitNodeMain);
    final addressWif = await service.getBitcoinAddressWIF(bitNodeMain);
    final bitcoinPrivKey = await service.getBitcoinPrivKey(bitNodeMain);
    final bitTestAddy = await service.getBitcoinAddressTest(bitNodeTest);
    final bitTestPubKey = await service.getBitcoinPubKey(bitNodeTest);
    final bitTestWif = await service.getBitcoinAddressWIF(bitNodeTest);
    final bitTestPrivKey = await service.getBitcoinPrivKey(bitNodeTest);
    final UserWalletsModel userWalletData = UserWalletsModel(
        Random().nextInt(34556920),
        ethAddress,
        ethPrivKey,
        bitcoinAddress,
        addressWif,
        bitcoinPubKey,
        bitcoinPrivKey,
        bitTestAddy,
        bitTestWif,
        bitTestPubKey,
        bitTestPrivKey,
        mnemonic);
    await addUserDetails(userWalletData);
  }

  Future addUserDetails(UserWalletsModel userWalletsModel) async {
    final box = Hive.box('wallets');
    await box.put(userWalletsModel.ethAddress.toString(), userWalletsModel);
    await box.put('activeWallet', userWalletsModel.ethAddress.toString());
  }
}
