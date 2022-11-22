// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walletModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserWalletsModelAdapter extends TypeAdapter<UserWalletsModel> {
  @override
  final int typeId = 1;

  @override
  UserWalletsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserWalletsModel(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserWalletsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.walletId)
      ..writeByte(1)
      ..write(obj.ethAddress)
      ..writeByte(2)
      ..write(obj.ethPrivKey)
      ..writeByte(3)
      ..write(obj.bitcoinAddress)
      ..writeByte(4)
      ..write(obj.bitAddressWif)
      ..writeByte(5)
      ..write(obj.bitPublicKey)
      ..writeByte(6)
      ..write(obj.bitPrivAddress)
      ..writeByte(7)
      ..write(obj.bitTestAddress)
      ..writeByte(8)
      ..write(obj.bitTestWif)
      ..writeByte(9)
      ..write(obj.bitTestPubKey)
      ..writeByte(10)
      ..write(obj.bitTestPrivKey)
      ..writeByte(11)
      ..write(obj.mnemonic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserWalletsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
