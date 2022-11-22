// ignore_for_file: prefer_typing_uninitialized_variables

class TransferData {
  TransferData(
      {this.client,
      required this.logoAsset,
      required this.address,
      required this.tokenBalance,
      required this.tokenNameGecko,
      required this.sendMethod,
      required this.chain,
      required this.tokenNameShort,
      required this.tokenName});
  var client;
  final String tokenNameShort;
  final String logoAsset;
  final String address;
  final String tokenName;
  final String tokenNameGecko;
  final String chain;
  final Future<double> Function() tokenBalance;
  final Future<String> Function(double enteredAmount, String receiver)
      sendMethod;
}
