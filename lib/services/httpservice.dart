import 'package:demo_stock/models/OHLC.dart';
import 'package:demo_stock/models/AllCoins.dart';
import 'package:demo_stock/models/chartData.dart';
import 'package:dio/dio.dart';

class HttpService {
  var coinrank = 'coinranking9ed4ef14d3d02ce6c6ab84531f43c7cad9e6147a80e13e80';

  List<ChartData> getChartData(Ohlc ohlc) {
    List<ChartData> lcd = [];
    for (var i = 0; i < ohlc.data.data.length; i++) {
      print('ohlc.');
      lcd.add(ChartData(
          ohlc.data.data[i].time,
          ohlc.data.data[i].open,
          ohlc.data.data[i].close,
          ohlc.data.data[i].high,
          ohlc.data.data[i].low));
    }
    return lcd;
  }

  Future<List<ChartData>> getOHLC(Coin coin) async {
    try {
      var dio = Dio();
      Response response = await dio.get(
          'https://min-api.cryptocompare.com/data/v2/histoday?fsym=${coin.symbol.toUpperCase()}&tsym=USD&limit=100');
      if (response.statusCode == 200) {
        Ohlc temp = Ohlc.fromJson(response.data);
        return getChartData(temp);
      } else {
        print('${response.statusCode} : ${response.data['data'][0]}');
        throw response.statusCode;
      }
    } catch (e) {
      print(
          "/////////////////////////////////////////////////////////////////////////////");
      print(e);
      print(
          ".............................................................................");
      return null;
    }
  }

  // ignore: non_constant_identifier_names

  // ignore: missing_return
  Future<AllCoins> getCoins() async {
    try {
      var dio = Dio();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {
          'x-access-token': coinrank,
          'Accepts': 'application/json'
        };
        options.headers.addAll(customHeaders);
        return options;
      }));
      Response response = await dio.get('https://api.coinranking.com/v2/coins');
      print(response.data);
      if (response.statusCode == 200) {
        return AllCoins.fromJson(response.data);
      } else {
        print('${response.statusCode} : ${response.data}');
        throw response.statusCode;
      }
    } catch (e) {
      print(
          "/////////////////////////////////////////////////////////////////////////////");
      print(e);
      print(
          ".............................................................................");
    }
  }
}
