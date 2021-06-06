import 'package:demo_stock/models/chart.dart';
import 'package:demo_stock/models/AllCoins.dart';
import 'package:dio/dio.dart';
//import 'package:http/http.dart' as http;

class HttpService {
  var marketcap = '2c72b754-49ea-453d-996d-72b9fda28683',
      coinAPI = '529BE7E4-8945-4D61-91FF-CB8FEF3C517B',
      coinrank = 'coinranking9ed4ef14d3d02ce6c6ab84531f43c7cad9e6147a80e13e80';

  // ignore: missing_return

  Future<Chart> GetChart(String uuid) async {
    try {
      var dio = Dio();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {
          'x-access-token': coinrank,
        };
        options.headers.addAll(customHeaders);
        return options;
      }));
      Response response = await dio.get(
          'https://api.coinranking.com/v2/coin/$uuid/history?timePeriod=7d&referenceCurrencyUuid=yhjMzLPhuIDl');
      print(response.data);
      if (response.statusCode == 200) {
        return Chart.fromJson(response.data);
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
