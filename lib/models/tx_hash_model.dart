// To parse this JSON data, do
//
//     final txHashModel = txHashModelFromJson(jsonString);

import 'dart:convert';

TxHashModel txHashModelFromJson(String str) =>
    TxHashModel.fromJson(json.decode(str));

String txHashModelToJson(TxHashModel data) => json.encode(data.toJson());

class TxHashModel {
  TxHashModel({
    required this.txId,
  });

  String txId;

  factory TxHashModel.fromJson(Map<String, dynamic> json) => TxHashModel(
        txId: json["txId"],
      );

  Map<String, dynamic> toJson() => {
        "txId": txId,
      };
}
