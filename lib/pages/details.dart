import 'package:demo_stock/models/chart.dart';
import 'package:demo_stock/services/httpservice.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String uuid;

  const Details({Key key, this.uuid}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState(uuid);
}

class _DetailsState extends State<Details> {
  final String uuid;
  List<History> _chartData;
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(1622536878000);
  _DetailsState(this.uuid);
  @override
  Widget build(BuildContext context) {
    print(dt);
    return SafeArea(
        child: Column(children: [
      Container(
          child: FutureBuilder<Chart>(
        future: HttpService().GetChart(uuid),
        builder: (BuildContext context, AsyncSnapshot<Chart> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return Container(
                child: SfCartesianChart(
                  series: <ChartSeries>[
                    LineSeries<History, double>(
                      // ignore: non_constant_identifier_names

                      selectionBehavior: SelectionBehavior(enable: true),
                      dataSource: snapshot.data.data.history,
                      xAxisName: 'date',
                      yAxisName: 'USD',
                      yValueMapper: (History data, _) =>
                          double.parse(data.price),
                      xValueMapper: (History data, _) =>
                          data.timestamp.microsecondsSinceEpoch.toDouble(),
                      dataLabelMapper: (History data, _) =>
                          data.timestamp.toString(),
                      // markerSettings: MarkerSettings(isVisible: true))
                    )
                  ],
                ),
              );
          }
        },
      )),
      Container(
        child: Row(
          children: [],
        ),
      )
    ]));
  }
}
