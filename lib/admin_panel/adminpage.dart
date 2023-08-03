import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _userData = [];
  List<Map<String, dynamic>> _orderData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchOrderData();
  }

  Future<void> _fetchUserData() async {
    try {
      // TODO: Retrieve user data from Firebase Authentication (requires Firebase Admin SDK or Cloud Function)
      // For example:
      // final users = await getUsersFromAuthentication();
      // setState(() {
      //   _userData = users;
      // });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchOrderData() async {
    try {
      final orderCollection = _firestore.collection('orders');
      final querySnapshot = await orderCollection.get();
      final orderData = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        _orderData = orderData;
      });
    } catch (e) {
      print('Error fetching order data: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate back to login screen or home page
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Display user data (if available)
          _userData.isEmpty
              ? Center(child: Text('No user data available'))
              : DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Mobile No')),
                  ],
                  rows: _userData.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['name'])),
                      DataCell(Text(user['email'])),
                      DataCell(Text(user['mobileNo'])),
                    ]);
                  }).toList(),
                ),
          Divider(),
          // Display order data
          _orderData.isEmpty
              ? Center(child: Text('No order data available'))
              : DataTable(
                  columns: const [
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Cylinder')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Sector')),
                    DataColumn(label: Text('Street')),
                    DataColumn(label: Text('House No')),
                  ],
                  rows: _orderData.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order['location'])),
                      DataCell(Text(order['cylinder'])),
                      DataCell(Text(order['quantity'])),
                      DataCell(Text(order['sector'])),
                      DataCell(Text(order['street'])),
                      DataCell(Text(order['houseNo'])),
                    ]);
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

// Implement Admin Login Page and Authentication as per your requirements
