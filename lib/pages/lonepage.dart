import 'package:demo_stock/models/loneData.dart';
import 'package:demo_stock/services/databaseservices.dart';
import 'package:flutter/material.dart';

class LonePage extends StatefulWidget {
  @override
  _LonePageState createState() => _LonePageState();
}

class _LonePageState extends State<LonePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.only(top: 50),
        child: FutureBuilder<List<LoneData>>(
            future: DatabaseServices().getLones(),
            builder:
                (BuildContext context, AsyncSnapshot<List<LoneData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                '${snapshot.data[index].value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              subtitle: Text(
                                '${snapshot.data[index].dt}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            color: Colors.lightBlueAccent.shade700,
                          ));
                    },
                  );
                }
              }
            }),
      ),
    );
  }
}
