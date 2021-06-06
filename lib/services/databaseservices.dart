import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_stock/models/AllCoins.dart';

class DatabaseServices {
  final CollectionReference userAssets =
      Firestore.instance.collection('userAssets');
  Future<void> onCreate(String userid, List<Coin> coins) async {
    for (var i = 0; i < coins.length; i++) {
      await userAssets.document(userid).setData({
        coins[i].name: 0.0,
      });
    }
  }
}
