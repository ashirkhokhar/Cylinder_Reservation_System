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
              DataColumn(
                  label: Text(
                'Location',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'Cylinder',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'Quantity',
                style: GoogleFonts.poppins(),
              )), // Status column
              DataColumn(
                  label: Text(
                'Sector',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'House No',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'Street',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'Phone No',
                style: GoogleFonts.poppins(),
              )),
              DataColumn(
                  label: Text(
                'Status',
                style: GoogleFonts.poppins(),
              )),
              // Display Timestamp
            ],
            rows: orderProvider.orders.asMap().entries.map((entry) {
              final index = entry.key + 1; // Serial number
              final order = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text(
                    '$index',
                    style: GoogleFonts.poppins(),
                  )), // Display serial number
                  DataCell(Text(
                    order.selectedLocation,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.selectedCylinder,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.selectedQuantity,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.sector,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.houseNo,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.street,
                    style: GoogleFonts.poppins(),
                  )),
                  DataCell(Text(
                    order.phoneNumber,
                    style: GoogleFonts.poppins(),
                  )),

                  // Display Timestamp
                  DataCell(Text(
                    'Pending',
                    style: GoogleFonts.poppins(),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
