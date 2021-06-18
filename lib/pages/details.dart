import 'package:demo_stock/Login%20and%20Signup/constants.dart';
import 'package:demo_stock/models/AllCoins.dart';
import 'package:intl/intl.dart';
import 'package:demo_stock/models/chartData.dart';
import 'package:demo_stock/models/pair.dart';
import 'package:demo_stock/services/databaseservices.dart';
import 'package:demo_stock/services/httpservice.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class Details extends StatefulWidget {
  final Coin coin;

  const Details({Key key, this.coin}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState(coin);
}

class _DetailsState extends State<Details> {
  TextEditingController _usd = TextEditingController();
  TextEditingController _selected = TextEditingController();
  TrackballBehavior _trackBall;
  final Coin coin;
  double usd = 0.0, currentCoin;
  Pair pair;
  double lowest;
  void setData() async {
    setState(() {});
  }

  @override
  void initState() {
    _trackBall = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  void zoom(ZoomPanArgs args) {
    print(args.currentZoomFactor);
  }

  void setValue() async {
    pair = await DatabaseServices().getPair(coin.name);
    if (pair.usd != null)
      usd = pair.usd;
    else
      usd = 0.0;
    if (pair.selected != null)
      currentCoin = pair.selected;
    else
      currentCoin = 0.0;
    setData();
  }

  @override
  _DetailsState(this.coin);
  @override
  Widget build(BuildContext context) {
    if (usd == null || currentCoin == null) setValue();
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF303F9F),
            ],
            stops: [0.1, 0.6, 0.65, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
              top: true,
              child: Column(children: [
                SizedBox(
                  height: 45,
                ),
                Container(
                    child: FutureBuilder<List<ChartData>>(
                  future: HttpService().getOHLC(coin),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ChartData>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else {
                        lowest = snapshot.data[0].low;
                        for (var i = 0; i < 15; i++) {
                          if (lowest > snapshot.data[i].low)
                            lowest = snapshot.data[i].low;
                        }
                        return Container(
                          child: SfCartesianChart(
                            backgroundColor: Colors.transparent,
                            trackballBehavior: _trackBall,
                            zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true, enablePanning: true),
                            onZooming: (ZoomPanArgs args) => zoom(args),
                            series: <CandleSeries>[
                              CandleSeries<ChartData, DateTime>(

                                  //showIndicationForSameValues: true,
                                  opacity: .9,
                                  bearColor: Colors.red,
                                  enableSolidCandles: true,
                                  bullColor: Colors.green,
                                  dataSource: snapshot.data,
                                  xValueMapper: (ChartData chart, _) => chart.x,
                                  openValueMapper: (ChartData chart, _) =>
                                      chart.open,
                                  lowValueMapper: (ChartData chart, _) =>
                                      chart.low,
                                  highValueMapper: (ChartData chart, _) =>
                                      chart.high,
                                  closeValueMapper: (ChartData chart, _) =>
                                      chart.close),
                            ],
                            primaryXAxis: DateTimeAxis(
                                enableAutoIntervalOnZooming: true,
                                dateFormat: DateFormat.Md(),
                                interval: 3),
                            primaryYAxis: NumericAxis(
                                enableAutoIntervalOnZooming: true,
                                numberFormat: NumberFormat.simpleCurrency(),
                                minimum: lowest * 0.8),
                          ),
                        );
                      }
                    }
                  },
                )),
                SizedBox(
                  height: 25,
                ),
                Text(
                  '${coin.symbol}  ${double.parse(coin.price).toStringAsFixed(4)} USD',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Column(children: [
                            Text(
                              '    USD',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            Text(
                              '    $usd',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )
                          ]),
                          Expanded(
                            child: Icon(
                              Icons.sync_alt_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Column(children: [
                            Text(
                              '${coin.name}    ',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            Text(
                              '$currentCoin    ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                _buildUSDTF(coin),
                SizedBox(
                  height: 25,
                ),
                _buildSelectedTF(coin),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          pair = await DatabaseServices().getPair(coin.name);
                          await DatabaseServices().buyAsset(
                              coin, double.parse(_usd.text), pair, context);
                          setValue();
                        },
                        child: Text('Buy')),
                    SizedBox(
                      width: 50,
                    ),
                    TextButton(
                        onPressed: () async {
                          return ConfirmationSlider(
                            onConfirmation: () async {
                              Pair pair =
                                  await DatabaseServices().getPair(coin.name);
                              await DatabaseServices().sellAsset(coin,
                                  double.parse(_selected.text), pair, context);
                              setValue();
                            },
                          );
                        },
                        child: Text('Sell')),
                  ],
                  
                )
              ])),
        ),
      ),
    );
  }

  Widget _buildBuyBtn(Coin coin) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 35.0,
      ),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (contex) => AlertDialog(
                    title: Text('Cofirmation'),
                    content: Text(
                        'Are you want Buy ${coin.symbol} at ${double.parse(coin.price).toStringAsFixed(3)}'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(contex);
                          },
                          child: Text('cancel')),
                      TextButton(
                          onPressed: () async {
                            Pair pair =
                                await DatabaseServices().getPair(coin.name);
                            await DatabaseServices().sellAsset(coin,
                                double.parse(_selected.text), pair, context);
                            setValue();
                          },
                          child: Text('Buy')),
                    ],
                  ));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Add 100\$',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildUSDTF(Coin coin) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value == '')
                _selected.text = 0.toString();
              else
                _selected.text =
                    (double.parse(value) / double.parse(coin.price)).toString();
            },
            controller: _usd,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: CircleAvatar(
                  radius: 19,
                  child: Image(
                    image: NetworkImage(
                      'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Dollar-USD-icon.png',
                    ),
                  ),
                ),
              ),
              hintText: 'Amount In USD',
              hintStyle: kHintTextStyle,
            ),
          )),
    );
  }

  Widget _buildSelectedTF(Coin coin) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) {
              if (value == '')
                _usd.text = 0.toString();
              else
                _usd.text =
                    (double.parse(value) * double.parse(coin.price)).toString();
            },
            keyboardType: TextInputType.number,
            controller: _selected,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: CircleAvatar(
                  radius: 19,
                  child: Image(
                    image: NetworkImage(
                      '${coin.iconUrl.replaceAll('.svg', '.png')}',
                    ),
                  ),
                ),
              ),
              hintText: 'Amount In USD',
              hintStyle: kHintTextStyle,
            ),
          )),
    );
  }
}
