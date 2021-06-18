import 'package:flutter/cupertino.dart';

class TransactionData {
  final int dt;
  final String nameOFCrypto, logo;
  final double volumeOfCrypto, price;
  final String type;
  TransactionData(
      this.dt, this.nameOFCrypto, this.volumeOfCrypto, this.price, this.type, this.logo);
}
