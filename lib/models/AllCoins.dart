// To parse this JSON data, do
//
//     final allCoins = allCoinsFromJson(jsonString);

import 'dart:convert';

AllCoins allCoinsFromJson(String str) => AllCoins.fromJson(json.decode(str));

String allCoinsToJson(AllCoins data) => json.encode(data.toJson());

class AllCoins {
    AllCoins({
        this.status,
        this.data,
    });

    String status;
    Data data;

    factory AllCoins.fromJson(Map<String, dynamic> json) => AllCoins(
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
        this.stats,
        this.coins,
    });

    Stats stats;
    List<Coin> coins;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        stats: Stats.fromJson(json["stats"]),
        coins: List<Coin>.from(json["coins"].map((x) => Coin.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "stats": stats.toJson(),
        "coins": List<dynamic>.from(coins.map((x) => x.toJson())),
    };
}

class Coin {
    Coin({
        this.uuid,
        this.symbol,
        this.name,
        this.color,
        this.iconUrl,
        this.marketCap,
        this.price,
        this.btcPrice,
        this.listedAt,
        this.change,
        this.rank,
        this.sparkline,
        this.coinrankingUrl,
        this.the24HVolume,
    });

    String uuid;
    String symbol;
    String name;
    String color;
    String iconUrl;
    String marketCap;
    String price;
    String btcPrice;
    int listedAt;
    String change;
    int rank;
    List<String> sparkline;
    String coinrankingUrl;
    String the24HVolume;

    factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        uuid: json["uuid"],
        symbol: json["symbol"],
        name: json["name"],
        color: json["color"],
        iconUrl: json["iconUrl"],
        marketCap: json["marketCap"],
        price: json["price"],
        btcPrice: json["btcPrice"],
        listedAt: json["listedAt"],
        change: json["change"],
        rank: json["rank"],
        sparkline: List<String>.from(json["sparkline"].map((x) => x)),
        coinrankingUrl: json["coinrankingUrl"],
        the24HVolume: json["24hVolume"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "symbol": symbol,
        "name": name,
        "color": color,
        "iconUrl": iconUrl,
        "marketCap": marketCap,
        "price": price,
        "btcPrice": btcPrice,
        "listedAt": listedAt,
        "change": change,
        "rank": rank,
        "sparkline": List<dynamic>.from(sparkline.map((x) => x)),
        "coinrankingUrl": coinrankingUrl,
        "24hVolume": the24HVolume,
    };
}

class Stats {
    Stats({
        this.total,
        this.totalMarkets,
        this.totalExchanges,
        this.totalMarketCap,
        this.total24HVolume,
    });

    int total;
    int totalMarkets;
    int totalExchanges;
    String totalMarketCap;
    String total24HVolume;

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        total: json["total"],
        totalMarkets: json["totalMarkets"],
        totalExchanges: json["totalExchanges"],
        totalMarketCap: json["totalMarketCap"],
        total24HVolume: json["total24hVolume"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "totalMarkets": totalMarkets,
        "totalExchanges": totalExchanges,
        "totalMarketCap": totalMarketCap,
        "total24hVolume": total24HVolume,
    };
}
