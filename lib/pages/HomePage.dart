import 'package:demo_stock/models/AllCoins.dart';

import 'package:demo_stock/pages/details.dart';

import 'package:flutter/services.dart';
import 'package:demo_stock/services/httpservice.dart';
import "package:flutter/material.dart";
import 'package:slimy_card/slimy_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _changecolor;
  String today, past;
  List<Color> _color = [
    Colors.amber[100],
    Colors.brown[200],
    Colors.teal[200],
    Colors.red[100],
    Colors.purple[100],
    Colors.pink[100],
    Colors.lightGreen[200],
    Colors.deepOrange[200],
    Colors.indigo[100]
  ];
 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
            //color: Colors.blue[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: FutureBuilder<AllCoins>(
                  future: HttpService().getCoins(),
                  builder:
                      (BuildContext context, AsyncSnapshot<AllCoins> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else {
                        return StreamBuilder(
                            stream: slimyCard.stream,
                            builder: (context, snap) {
                              return ListView.builder(
                                itemCount: snapshot.data.data.coins.length,
                                itemBuilder: (context, index) {
                                  if (double.parse(snapshot
                                          .data.data.coins[index].change) >=
                                      0.0) {
                                    _changecolor =
                                        Colors.lightGreenAccent.shade700;
                                  } else {
                                    _changecolor = Colors.redAccent[700];
                                  }
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 8, 30, 3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: _color[index % _color.length]),
                                      padding: EdgeInsets.fromLTRB(8, 5, 7, 2),
                                      child: SlimyCard(
                                        topCardHeight: 210,
                                        width: 300,
                                        bottomCardHeight: 150,
                                        color: _changecolor,
                                        slimeEnabled: true,
                                        topCardWidget: topCardWidget(
                                            snapshot
                                                .data.data.coins[index].iconUrl
                                                .replaceAll('.svg', '.png'),
                                            snapshot.data.data.coins[index]),
                                        bottomCardWidget: bottomCardWidget(
                                            snapshot.data.data.coins[index]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      }
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget topCardWidget(String imagePath, Coin coin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Details(coin: coin)));
            },
            child: Image(
              image: NetworkImage(imagePath),
              height: 70,
              width: 70,
            )),
        SizedBox(height: 15),
        Text(
          coin.name,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 15),
        Text(
          double.parse(coin.price).toStringAsFixed(4),
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget bottomCardWidget(Coin coin) {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Text(
        double.parse(coin.change) >= 0
            ? 'Has Rised ${double.parse(coin.change).toStringAsFixed(3)}% in last\n 24 Hours'
            : 'Has Fallan ${double.parse(coin.change).toStringAsFixed(3)}% in last\n24 Hours',
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        double.parse(coin.change) >= 0
            ? 'No once know when crypto falls \n So be cearful'
            : 'In a long run it will definatly goes UP',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
