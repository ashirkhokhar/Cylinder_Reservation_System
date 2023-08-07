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
        title: Text(
          "Order History",
          style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white),
        ),
        // ... (other app bar settings)
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Location')),
            const DataColumn(label: Text('Cylinder')),
            const DataColumn(label: Text('Quantity')),
            const DataColumn(label: Text('Sector')),
            const DataColumn(label: Text('House No')),
            const DataColumn(label: Text('Street')),
            const DataColumn(label: Text('Phone No')),
          ],
          rows: orderProvider.orders.map((order) {
            return DataRow(
              cells: [
                DataCell(Text(order.selectedLocation)),
                DataCell(Text(order.selectedCylinder)),
                DataCell(Text(order.selectedQuantity)),
                DataCell(Text(order.sector)),
                DataCell(Text(order.houseNo)),
                DataCell(Text(order.street)),
                DataCell(Text(order.phoneNumber)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
