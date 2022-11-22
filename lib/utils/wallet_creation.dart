import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart' as web3;

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<web3.EthereumAddress> getPublicKey(String privateKey);
}

class WalletAddress implements WalletAddressService {
  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    Chain chain = Chain.seed(seed);
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");
    String privateKey = key.privateKeyHex().substring(2);

    return privateKey;
  }

  Future getBitcoinNode(String mnemonic) async {
    final seedBit = bip39.mnemonicToSeed(mnemonic);
    // var hdWallet = HDWallet.fromSeed(seedBit, network: bitcoin);
    // final node = hdWallet.derivePath("m/44'/0'/0'/0/0");
    final root = bip32.BIP32.fromSeed(seedBit);
    final nodeP = root.derivePath("m/84'/0'/0'/0/0"); //MainNet node(p2wpkh)
    return nodeP;
  }

  Future getBitcoinTestNode(String mnemonic) async {
    final seedBit = bip39.mnemonicToSeed(mnemonic);
    final type = bip32.NetworkType(
        wif: 0xef,
        bip32: bip32.Bip32Type(public: 0x043587cf, private: 0x04358394));
    // var hdWallet = HDWallet.fromSeed(seedBit, network: testnet);
    // final nodeT = hdWallet.derivePath("m/49'/1'/0'/0/0");
    final rootTest = bip32.BIP32.fromSeed(seedBit, type);
    final nodeTest =
        rootTest.derivePath("m/84'/1'/0'/0/0"); //Testnet node(p2wpkh)
    // final addy = hdWallet.address;
    // final wif = hdWallet.wif;
    // final privKey = hdWallet.privKey;
    // final pubKey = hdWallet.pubKey;
    // final privKey = HEX.encode(nodeTest.privateKey!);
    return nodeTest;
  }

  @override
  Future<web3.EthereumAddress> getPublicKey(String privateKey) async {
    final private = web3.EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    return address;
  }

  Future<String> getBitcoinAddress(bip32.BIP32 node) async {
    final bitcoinAddress = P2WPKH(
      data: PaymentData(pubkey: node.publicKey),
    ).data.address;
    // final bitcoinAddress = node.address;
    return bitcoinAddress; //Test address
  }

  Future<String> getBitcoinAddressTest(bip32.BIP32 node) async {
    final bitcoinAddress =
        P2WPKH(data: PaymentData(pubkey: node.publicKey), network: testnet)
            .data
            .address;
    // final bitcoinAddress = node.address;
    return bitcoinAddress; //Test address
  }

  Future<String> getBitcoinAddressWIF(bip32.BIP32 node) async {
    // final wif = node.wif;
    final wif = node.toWIF();
    print(wif);
    return wif;
  }

  Future<String> getBitcoinPubKey(bip32.BIP32 node) async {
    // final bitPubKey = node.pubKey;
    final bitPubKey = HEX.encode(node.publicKey);
    return bitPubKey;
  }

  Future<String> getBitcoinPrivKey(bip32.BIP32 node) async {
    // final bitPrivKey = node.privKey;
    final bitPrivKey = HEX.encode(node.publicKey);
    return bitPrivKey;
  }
}
