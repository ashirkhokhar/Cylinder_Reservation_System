import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ordertable extends StatelessWidget {
  final String selectedLocation;
  final String selectedCylinder;
  final String selectedQuantity;
  final String phoneNumber;
  final String sector;
  final String houseno;
  final String street;

  const Ordertable({
    required this.selectedLocation,
    required this.selectedCylinder,
    required this.selectedQuantity,
    required this.phoneNumber,
    required this.sector,
    required this.houseno,
    required this.street,
  });

  void _saveOrderToFirestore(BuildContext context) {
    FirebaseFirestore.instance.collection('orderhistory').add({
      'selectedLocation': selectedLocation,
      'selectedCylinder': selectedCylinder,
      'selectedQuantity': selectedQuantity,
      'phoneNumber': phoneNumber,
      'sector': sector,
      'street': street,
      'houseno': houseno,
    }).then((value) {
      print('Order saved to Firestore!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your order has been placed successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      print('Error saving order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while placing your order.'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("place Order",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildOrderHistoryTable(),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () => _saveOrderToFirestore(context),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderHistoryTable() {
    return Table(
      columnWidths: {0: const FixedColumnWidth(150.0)},
      border: TableBorder.all(color: Colors.grey),
      children: [
        const TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Column Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Value:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(' Location:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(selectedLocation),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Cylinder:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(selectedCylinder),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Quantity:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(selectedQuantity),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Phone Number:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(phoneNumber),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sector:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(sector),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Street:'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(street),
              ),
            ),
          ],
        ),
        TableRow(children: [
          const TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('House No:'),
            ),
          ),
          TableCell(
            child: Padding(
                padding: const EdgeInsets.all(8.0), child: Text(houseno)),
          ),
        ]),
      ],
    );
  }
}
