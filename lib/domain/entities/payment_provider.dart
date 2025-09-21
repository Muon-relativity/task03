import 'package:flutter/material.dart';

class PaymentProvider {
  final String name;
  final String key;
  final IconData icon;
  final Color color;

  const PaymentProvider(this.name, this.key, this.icon, this.color);
}