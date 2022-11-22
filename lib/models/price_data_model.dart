// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CoinPriceData coinPriceDataFromJson(String str, String tokenName) =>
    CoinPriceData.fromJson(json.decode(str), tokenName);

String coinPriceDataToJson(CoinPriceData data, String tokenName) =>
    json.encode(data.toJson(tokenName));

class CoinPriceData {
  CoinPriceData({
    required this.token,
  });

  Coin token;

  factory CoinPriceData.fromJson(Map<String, dynamic> json, String tokenName) =>
      CoinPriceData(
        token: Coin.fromJson(json[tokenName]),
      );

  Map<String, dynamic> toJson(String tokenName) => {
        tokenName: token.toJson(),
      };
}

class Coin {
  Coin({
    required this.usd,
  });

  double usd;

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        usd: json["usd"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "usd": usd,
      };
}
