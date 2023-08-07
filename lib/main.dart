import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Details/order_model.dart';
import 'Details/order_provider.dart';
import 'MenuScreen/Main_MenuScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final ordersData = prefs.getString('orders');
  final orderProvider = OrderProvider();

  if (ordersData != null) {
    final ordersList = (jsonDecode(ordersData) as List)
        .map((data) => OrderData.fromJson(data))
        .toList();
    orderProvider.loadOrders(ordersList);
  }

  runApp(
    ChangeNotifierProvider.value(
      value: orderProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}
