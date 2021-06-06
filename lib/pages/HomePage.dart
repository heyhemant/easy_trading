import 'package:demo_stock/main.dart';
import 'package:demo_stock/models/AllCoins.dart';
import 'package:demo_stock/pages/details.dart';
import 'package:demo_stock/services/authsevices.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_stock/services/httpservice.dart';
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData _arrow;
  // ignore: unused_field
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
      // ignore: deprecated_member_use
      floatingActionButton: FlatButton(
        child: CircleAvatar(
          child: Icon(Icons.exit_to_app),
          radius: 30,
        ),
        onPressed: () {
          AuthServices().signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      ),
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
                        return ListView.builder(
                          itemCount: snapshot.data.data.coins.length,
                          itemBuilder: (context, index) {
                            if (double.parse(
                                    snapshot.data.data.coins[index].change) >=
                                0.0) {
                              _arrow = Icons.arrow_circle_up;
                              _changecolor = Colors.green[700];
                            } else {
                              _arrow = Icons.arrow_circle_down;
                              _changecolor = Colors.red[900];
                            }
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 3),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: _color[index % _color.length]),
                                padding: EdgeInsets.fromLTRB(8, 5, 7, 2),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Details(
                                                uuid: snapshot.data.data
                                                    .coins[index].uuid)));
                                  },
                                  subtitle: Text(
                                      '${double.parse((snapshot.data.data.coins[index].price)).toStringAsFixed(5)} USD',
                                      style: GoogleFonts.nunito(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  leading: Image.network(
                                    '${snapshot.data.data.coins[index].iconUrl.replaceAll('.svg', '.png')}',
                                    height: 42.0,
                                    width: 42.0,
                                  ),
                                  title: Text(
                                      snapshot.data.data.coins[index].name,
                                      style: GoogleFonts.openSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  trailing: Column(children: [
                                    Icon(
                                      _arrow,
                                      color: _changecolor,
                                    ),
                                    Text(
                                        '${double.parse((snapshot.data.data.coins[index].change)).toStringAsFixed(3)}%',
                                        style: GoogleFonts.sourceCodePro(
                                            fontSize: 15,
                                            color: _changecolor,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
