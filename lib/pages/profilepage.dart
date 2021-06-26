import 'package:demo_stock/main.dart';
import 'package:demo_stock/models/user_data.dart';
import 'package:demo_stock/services/authsevices.dart';
import 'package:demo_stock/services/databaseservices.dart';
import 'package:flutter/material.dart';
import 'package:demo_stock/models/userassets.dart';
import 'package:slimy_card/slimy_card.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ignore: avoid_init_to_null
  double totalUSD = null;

  UserData userData;

  void getData() async {
    UserAssets a = await DatabaseServices().getAsset('USD');
    UserData temp = await DatabaseServices().getUserData();
    print('${temp.name}    $a');
    setState(() {
      if (a != null) totalUSD = a.value;
      userData = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) getData();
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
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
            child: StreamBuilder(
                stream: slimyCard.stream,
                builder: (context, snap) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: SlimyCard(
                        topCardHeight: 250,
                        bottomCardHeight: 150,
                        color: Colors.lightBlueAccent.shade700,
                        topCardWidget: topCardWidget(totalUSD),
                        bottomCardWidget: bottomCardWidget(),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<List<UserAssets>>(
                        future: DatabaseServices().getAssets(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<UserAssets>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.hasError)
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            else {
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      if (snapshot.data[i].value == 0) {
                                        return SizedBox(
                                          height: 0.0,
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.black87,
                                            ),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                child: Image(
                                                  image: NetworkImage(
                                                      snapshot.data[i].icon),
                                                ),
                                              ),
                                              title: Text(
                                                snapshot.data[i].name,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              trailing: Text(
                                                  snapshot.data[i].value
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  );
                }),
          ),
        ]),
      ),
    );
  }

  Widget topCardWidget(double total_usd) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () {},
          onLongPress: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (contex) => AlertDialog(
                      title: Text('Cofirmation'),
                      content: Text('Are you want to sign out?'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(contex);
                            },
                            child: Text('cancel')),
                        TextButton(
                            onPressed: () async {
                              AuthServices().signOut();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            },
                            child: Text('Sign Out')),
                      ],
                    ));
          },
          child: CircleAvatar(
            radius: 45,
            child: userData != null
                ? Image.network(userData.pic)
                : CircularProgressIndicator(),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Available USD',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          total_usd.toString(),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }

  Widget bottomCardWidget() {
    return Column(children: [
      _buildAddUSDBtn(),
    ]);
  }

  Widget _buildAddUSDBtn() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 35.0,
      ),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          await DatabaseServices().addUSD(100);
          getData();
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
}
