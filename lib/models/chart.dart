import 'dart:convert';

Chart chartFromJson(String str) => Chart.fromJson(json.decode(str));

String chartToJson(Chart data) => json.encode(data.toJson());

class Chart {
  Chart({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.change,
    this.history,
  });

  String change;
  List<History> history;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        change: json["change"],
        history:
            List<History>.from(json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "change": change,
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class History {
  History({
    this.price,
    this.timestamp,
  });

  String price;
  DateTime timestamp;

  factory History.fromJson(Map<String, dynamic> json) => History(
        price: json["price"],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "timestamp": timestamp,
      };
}
