import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_stock/models/AllCoins.dart';
import 'package:demo_stock/models/loneData.dart';
import 'package:demo_stock/models/pair.dart';
import 'package:demo_stock/models/transaction.dart';
import 'package:demo_stock/models/user_data.dart';
import 'package:demo_stock/models/userassets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DatabaseServices {
  Future<UserAssets> getAsset(String name) async {
    DocumentSnapshot snapshot;
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    CollectionReference userAssets =
        Firestore.instance.collection('${_user.uid}-Assets');
    snapshot = await userAssets.document(name).get();
    print(snapshot['Name']);
    return UserAssets(snapshot['Name'], snapshot['Value'], snapshot['Logo']);
  }

  Future<bool> addUser(UserData data) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      CollectionReference reference =
          Firestore.instance.collection('UsersData');
      reference.document(_user.uid).setData({
        'Name': data.name,
        'Address': data.address,
        'Email': data.email,
        'Mobile': data.mobile,
        'Pic': data.pic
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserData> getUserData() async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      CollectionReference reference =
          Firestore.instance.collection('UsersData');
      DocumentSnapshot ds = await reference.document(_user.uid).get();
      UserData us = UserData(ds.data['Name'], ds.data['Pic'], ds.data['Email'],
          ds.data['Address'], ds.data['Mobile']);
      return us;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> check() async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      CollectionReference reference =
          Firestore.instance.collection('UsersData');
      DocumentSnapshot ds = await reference.document(_user.uid).get();
      if (ds.exists) {
        print(ds.documentID);
        return 1;
      } else
        return 2;
    } catch (e) {
      print(e);
      return 2;
    }
  }

  Future<List<UserAssets>> getAssets() async {
    QuerySnapshot quaryshapshot;
    List<UserAssets> ua = [];
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    quaryshapshot = await Firestore.instance
        .collection('${_user.uid}-Assets')
        .getDocuments();
    UserAssets temp;
    final List<DocumentSnapshot> documents = quaryshapshot.documents;
    for (var i = 0; i < documents.length; i++) {
      temp = UserAssets(
          documents[i]['Name'], documents[i]['Value'], documents[i]['Logo']);
      ua.add(temp);
    }
    return ua;
  }

  Future<Pair> getPair(String cryptoName) async {
    DocumentSnapshot snapshotUSD, snapshotSelected;
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    CollectionReference userAssets =
        Firestore.instance.collection('${_user.uid}-Assets');
    snapshotSelected = await userAssets.document(cryptoName).get();
    snapshotUSD = await userAssets.document('USD').get();
    Pair pair = Pair(snapshotUSD.data == null ? 0 : snapshotUSD['Value'],
        snapshotSelected.data == null ? 0 : snapshotSelected['Value']);
    print('${pair.selected}.............................${pair.usd}');
    return pair;
  }

  Future<List<LoneData>> getLones() async {
    QuerySnapshot quarysnapshot;
    List<LoneData> ld = [];
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    quarysnapshot =
        await Firestore.instance.collection('${_user.uid}-Lone').getDocuments();
    final List<DocumentSnapshot> documents = quarysnapshot.documents;
    for (var i = documents.length - 1; i >= 0; i--) {
      ld.add(LoneData(DateTime.fromMicrosecondsSinceEpoch(documents[i]['Time']),
          documents[i]['Value']));
    }
    return ld;
  }

  Future<List<TransactionData>> getTransctions() async {
    QuerySnapshot quaryshapshot;
    List<TransactionData> td = [];
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    quaryshapshot = await Firestore.instance
        .collection('${_user.uid}-Transaction')
        .getDocuments();
    final List<DocumentSnapshot> documents = quaryshapshot.documents;
    for (int i = documents.length - 1; i >= 0; i--) {
      TransactionData temp = TransactionData(
          documents[i]['Date Time'],
          documents[i]['Crypto Name'],
          documents[i]['Volume of Crypto'],
          documents[i]['Price'],
          documents[i]['Type'],
          documents[i]['logo']);
      td.add(temp);
    }
    return td;
  }

  Future<void> addTransaction(
      Coin coin, double volumeofCrypto, String type) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    CollectionReference userTransaction =
        Firestore.instance.collection('${_user.uid}-Transaction');
    int dt = DateTime.now().millisecondsSinceEpoch;
    await userTransaction.document(dt.toString()).setData({
      'Date Time': DateTime.now().microsecondsSinceEpoch,
      'Crypto Name': coin.name,
      'Volume of Crypto': volumeofCrypto,
      'Price': double.parse(coin.price),
      'Type': type,
      'logo': coin.iconUrl.replaceFirst('.svg', '.png')
    });
  }

  Future<void> addAsset(String name, String url, double value) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    CollectionReference userAssets =
        Firestore.instance.collection('${_user.uid}-Assets');
    DocumentSnapshot snap = await Firestore.instance
        .collection('${_user.uid}-Assets')
        .document(name)
        .get();
    if (!snap.exists) {
      await userAssets.document(name).setData({
        'Name': name,
        'Value': value,
        'Logo': url.replaceFirst('.svg', '.png')
      });
    } else {
      if (value + snap['Value'] >= 0) {
        await userAssets
            .document(name)
            .updateData({'Value': snap['Value'] + value});
      } else
        print('BSDK Gareeb');
    }
  }

  Future<void> buyAsset(
      Coin coin, double amountUSD, Pair pair, BuildContext context) async {
    if (pair.usd >= amountUSD) {
      await addAsset(
          coin.name, coin.iconUrl, amountUSD / double.parse(coin.price));
      await addAsset(
          'USD',
          'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Dollar-USD-icon.png',
          -amountUSD);
      await addTransaction(coin, amountUSD / double.parse(coin.price), 'Buy');
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (contex) => AlertDialog(
                title: Text('Enter Code'),
                content: Text('You Don\'t have enough USD'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(contex);
                      },
                      child: Text('OK')),
                ],
              ));
    }
  }

  Future<void> sellAsset(
      Coin coin, double amountAsset, Pair pair, BuildContext context) async {
    if (pair.selected >= amountAsset) {
      await addAsset(coin.name, coin.iconUrl, -amountAsset);
      await addAsset(
          'USD',
          'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Dollar-USD-icon.png',
          double.parse(coin.price) * amountAsset);
      await addTransaction(coin, amountAsset, 'Sell');
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (contex) => AlertDialog(
                title: Text('Enter Code'),
                content: Text(
                    'You Don\'t have enough ${(coin.symbol).toUpperCase()}'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(contex);
                      },
                      child: Text('OK')),
                ],
              ));
    }
  }

  Future<void> addUSD(double value) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap = await Firestore.instance
        .collection('${_user.uid}-Assets')
        .document('USD')
        .get();
    if (!snap.exists) {
      await addAsset(
          'USD',
          'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Dollar-USD-icon.png',
          0.0);
      snap = await Firestore.instance
          .collection('${_user.uid}-Assets')
          .document('USD')
          .get();
    }
    await Firestore.instance
        .collection('${_user.uid}-Lone')
        .document(DateTime.now().microsecondsSinceEpoch.toString())
        .setData(
            {'Value': value, 'Time': DateTime.now().microsecondsSinceEpoch});

    await Firestore.instance
        .collection('${_user.uid}-Assets')
        .document('USD')
        .updateData({'Value': snap['Value'] + value});
  }
}
