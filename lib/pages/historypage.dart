import 'package:demo_stock/models/transaction.dart';
import 'package:demo_stock/services/databaseservices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    Color _card;
    return SafeArea(
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
        child: Padding(
          padding: EdgeInsets.all(0),
          child: FutureBuilder<List<TransactionData>>(
            future: DatabaseServices().getTransctions(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TransactionData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 55),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data[index].type == 'Sell') {
                          _card = Colors.red;
                        } else {
                          _card = Colors.green;
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _card,
                            ),
                            child: ExpansionTile(
                              children: [
                                Text(
                                    '${DateTime.fromMicrosecondsSinceEpoch(snapshot.data[index].dt)}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${snapshot.data[index].volumeOfCrypto.toStringAsFixed(4)}',
                                        style: GoogleFonts.nunito(
                                            fontSize: 20,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ]),
                              title: Text(
                                  '${snapshot.data[index].nameOFCrypto}',
                                  style: GoogleFonts.nunito(
                                      fontSize: 22,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              leading: CircleAvatar(
                                child: Image(
                                    image: NetworkImage(
                                        snapshot.data[index].logo)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
