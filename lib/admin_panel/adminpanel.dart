// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Admin Panel",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: const AllOrdersList(),
    );
  }
}

class AllOrdersList extends StatelessWidget {
  const AllOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orderhistory').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No Orders Found');
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final orderData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.deepPurple[300],
                  title: Text(
                    'Order ${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'User: ${orderData['selectedLocation']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailsScreen(orderData: orderData),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Order Details",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Field')),
              const DataColumn(label: Text('Value')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Selected Location')),
                DataCell(Text(orderData['selectedLocation'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Selected Cylinder')),
                DataCell(Text(orderData['selectedCylinder'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Selected Quantity')),
                DataCell(Text(orderData['selectedQuantity'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Sector')),
                DataCell(Text(orderData['sector'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('House No')),
                DataCell(Text(orderData['houseno'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Street')),
                DataCell(Text(orderData['street'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Phone Number')),
                DataCell(Text(orderData['phoneNumber'])),
              ]),
              // Add more data rows as needed
            ],
          ),
        ),
      ),
    );
  }
}
