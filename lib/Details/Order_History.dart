// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'order_provider.dart';

class OrdersRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Order History",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Set vertical scroll direction
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(
                  label: Text('Serial No')), // Serial number column
              const DataColumn(label: Text('Location')),
              const DataColumn(label: Text('Cylinder')),
              const DataColumn(label: Text('Quantity')), // Status column
              const DataColumn(label: Text('Sector')),
              const DataColumn(label: Text('House No')),
              const DataColumn(label: Text('Street')),
              const DataColumn(label: Text('Phone No')),
              const DataColumn(label: Text('Status')),
            ],
            rows: orderProvider.orders.asMap().entries.map((entry) {
              final index = entry.key + 1; // Serial number
              final order = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('$index')), // Display serial number
                  DataCell(Text(order.selectedLocation)),
                  DataCell(Text(order.selectedCylinder)),
                  DataCell(Text(order
                      .selectedQuantity)), // Display "Pending" for all orders
                  DataCell(Text(order.sector)),
                  DataCell(Text(order.houseNo)),
                  DataCell(Text(order.street)),
                  DataCell(Text(order.phoneNumber)),
                  DataCell(Text('Pending')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
