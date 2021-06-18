import 'dart:convert';

Ohlc ohlcFromJson(String str) => Ohlc.fromJson(json.decode(str));

String ohlcToJson(Ohlc data) => json.encode(data.toJson());

class Ohlc {
  Ohlc({
    this.data,
  });

  Data data;

  factory Ohlc.fromJson(Map<String, dynamic> json) => Ohlc(
        data: Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
      };
}

class Data {
  Data({
    this.data,
  });

  List<Datum> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.time,
    this.high,
    this.low,
    this.open,
    this.close,
  });

  DateTime time;
  double high;
  double low;
  double open;

  double close;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        time: DateTime.fromMillisecondsSinceEpoch(json["time"] * 1000),
        high: json["high"].toDouble(),
        low: json["low"].toDouble(),
        open: json["open"].toDouble(),
        close: json["close"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "high": high,
        "low": low,
        "open": open,
        "close": close,
      };
}
