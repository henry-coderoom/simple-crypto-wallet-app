import 'package:hive/hive.dart';

part 'walletModel.g.dart';

@HiveType(typeId: 1)
class UserWalletsModel {
  @HiveField(0)
  int walletId;
  @HiveField(1)
  String ethAddress;
  @HiveField(2)
  String ethPrivKey;
  @HiveField(3)
  String bitcoinAddress;
  @HiveField(4)
  String bitAddressWif;
  @HiveField(5)
  String bitPublicKey;
  @HiveField(6)
  String bitPrivAddress;
  @HiveField(7)
  String bitTestAddress;
  @HiveField(8)
  String bitTestWif;
  @HiveField(9)
  String bitTestPubKey;
  @HiveField(10)
  String bitTestPrivKey;
  @HiveField(11)
  String mnemonic;
  UserWalletsModel(
    this.walletId,
    this.ethAddress,
    this.ethPrivKey,
    this.bitcoinAddress,
    this.bitAddressWif,
    this.bitPublicKey,
    this.bitPrivAddress,
    this.bitTestAddress,
    this.bitTestWif,
    this.bitTestPubKey,
    this.bitTestPrivKey,
    this.mnemonic,
  );
}
