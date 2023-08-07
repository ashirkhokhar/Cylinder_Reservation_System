import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderData> _orders = [];

  List<OrderData> get orders => _orders;

  void loadOrders(List<OrderData> orders) {
    _orders = orders;
    notifyListeners();
  }

  void addOrder(OrderData order) async {
    _orders.add(order);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final ordersList = _orders.map((order) => order.toJson()).toList();
    prefs.setString('orders', jsonEncode(ordersList));
  }
}
