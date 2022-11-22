// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

BitcoinAddressData bitcoinAddressDataFromJson(String str) =>
    BitcoinAddressData.fromJson(json.decode(str));

String bitcoinAddressDataToJson(BitcoinAddressData data) =>
    json.encode(data.toJson());

class BitcoinAddressData {
  BitcoinAddressData({
    required this.address,
    required this.totalReceived,
    required this.totalSent,
    required this.balance,
    required this.unconfirmedBalance,
    required this.finalBalance,
    required this.nTx,
    required this.unconfirmedNTx,
    required this.finalNTx,
    required this.txrefs,
    required this.unconfirmedTxrefs,
    required this.txUrl,
  });

  String address;
  int totalReceived;
  int totalSent;
  int balance;
  int unconfirmedBalance;
  int finalBalance;
  int nTx;
  int unconfirmedNTx;
  int finalNTx;
  List<Txref> txrefs;
  List<UnconfirmedTxref> unconfirmedTxrefs;
  String txUrl;

  factory BitcoinAddressData.fromJson(Map<String, dynamic> json) {
    return BitcoinAddressData(
      address: json["address"],
      totalReceived: json["total_received"],
      totalSent: json["total_sent"],
      balance: json["balance"],
      unconfirmedBalance: json["unconfirmed_balance"],
      finalBalance: json["final_balance"],
      nTx: json["n_tx"],
      unconfirmedNTx: json["unconfirmed_n_tx"],
      finalNTx: json["final_n_tx"],
      txrefs: (json["txrefs"] == null)
          ? []
          : List<Txref>.from(json["txrefs"].map((x) => Txref.fromJson(x))),
      unconfirmedTxrefs: (json["unconfirmed_txrefs"] == null)
          ? []
          : List<UnconfirmedTxref>.from(json["unconfirmed_txrefs"]
              .map((x) => UnconfirmedTxref.fromJson(x))),
      txUrl: json["tx_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "address": address,
        "total_received": totalReceived,
        "total_sent": totalSent,
        "balance": balance,
        "unconfirmed_balance": unconfirmedBalance,
        "final_balance": finalBalance,
        "n_tx": nTx,
        "unconfirmed_n_tx": unconfirmedNTx,
        "final_n_tx": finalNTx,
        "txrefs": List<dynamic>.from(txrefs.map((x) => x.toJson())),
        "unconfirmed_txrefs":
            List<dynamic>.from(unconfirmedTxrefs.map((x) => x.toJson())),
        "tx_url": txUrl,
      };
}

//
// Txref txrefFromJson(String str) => Txref.fromJson(json.decode(str));
//
// String txrefToJson(Txref data) => json.encode(data.toJson());
List<Txref> txrefFromJson(String str) =>
    List<Txref>.from(json.decode(str).map((x) => Txref.fromJson(x)));

String txrefToJson(List<Txref> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Txref {
  Txref({
    required this.txHash,
    required this.blockHeight,
    required this.txInputN,
    required this.txOutputN,
    required this.value,
    required this.refBalance,
    required this.confirmations,
    required this.confirmed,
    required this.doubleSpend,
    required this.spent,
    required this.spentBy,
  });

  String txHash;
  int blockHeight;
  int txInputN;
  int txOutputN;
  int value;
  int refBalance;
  int confirmations;
  DateTime confirmed;
  bool doubleSpend;
  bool spent;
  String spentBy;

  factory Txref.fromJson(Map<String, dynamic> json) => Txref(
        txHash: json["tx_hash"],
        blockHeight: json["block_height"],
        txInputN: json["tx_input_n"],
        txOutputN: json["tx_output_n"],
        value: json["value"],
        refBalance: json["ref_balance"],
        confirmations: json["confirmations"],
        confirmed: DateTime.parse(json["confirmed"]),
        doubleSpend: json["double_spend"],
        spent: (json["spent"] == null) ? null : json["spent"],
        spentBy: (json["spent_by"] == null) ? null : json["spent_by"],
      );

  Map<String, dynamic> toJson() => {
        "tx_hash": txHash,
        "block_height": blockHeight,
        "tx_input_n": txInputN,
        "tx_output_n": txOutputN,
        "value": value,
        "ref_balance": refBalance,
        "confirmations": confirmations,
        "confirmed": confirmed.toIso8601String(),
        "double_spend": doubleSpend,
        "spent": spent,
        "spent_by": spentBy,
      };
}

List<UnconfirmedTxref> unconfirmedTxrefFromJson(String str) =>
    List<UnconfirmedTxref>.from(
        json.decode(str).map((x) => UnconfirmedTxref.fromJson(x)));

String unconfirmedTxrefToJson(List<UnconfirmedTxref> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnconfirmedTxref {
  UnconfirmedTxref({
    required this.address,
    required this.txHash,
    required this.txInputN,
    required this.txOutputN,
    required this.value,
    required this.spent,
    required this.received,
    required this.confirmations,
    required this.doubleSpend,
    required this.preference,
  });

  String address;
  String txHash;
  int txInputN;
  int txOutputN;
  int value;
  bool spent;
  DateTime received;
  int confirmations;
  bool doubleSpend;
  String preference;

  factory UnconfirmedTxref.fromJson(Map<String, dynamic> json) =>
      UnconfirmedTxref(
        address: json["address"],
        txHash: json["tx_hash"],
        txInputN: json["tx_input_n"],
        txOutputN: json["tx_output_n"],
        value: json["value"],
        spent: json["spent"],
        received: DateTime.parse(json["received"]),
        confirmations: json["confirmations"],
        doubleSpend: json["double_spend"],
        preference: json["preference"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "tx_hash": txHash,
        "tx_input_n": txInputN,
        "tx_output_n": txOutputN,
        "value": value,
        "spent": spent,
        "received": received.toIso8601String(),
        "confirmations": confirmations,
        "double_spend": doubleSpend,
        "preference": preference,
      };
}
