// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/MenuScreen/Main_MenuScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Ordertable extends StatefulWidget {
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

  @override
  _OrdertableState createState() => _OrdertableState();
}

class _OrdertableState extends State<Ordertable> {
  bool isButtonDisabled = false;
  late Future<void> _delayedEnableButton;

  @override
  void initState() {
    super.initState();
    _delayedEnableButton = Future.value();
  }

  Future<void> _saveOrderToFirestore(BuildContext context) async {
    if (isButtonDisabled) {
      return;
    }

    setState(() {
      isButtonDisabled = true;
    });

    final now = DateTime.now();
    try {
      await FirebaseFirestore.instance.collection('orderhistory').add({
        'selectedLocation': widget.selectedLocation,
        'selectedCylinder': widget.selectedCylinder,
        'selectedQuantity': widget.selectedQuantity,
        'phoneNumber': widget.phoneNumber,
        'sector': widget.sector,
        'street': widget.street,
        'houseno': widget.houseno,
        'orderTimestamp': now, // Add the timestamp field
        'isNew': false,
        'status': 'New', // Add the status field
      });
      print('Order saved to Firestore!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your order has been placed successfully!'),
          duration: Duration(seconds: 3),
        ),
      );

      // Cancel the previous delayed future if it exists
      _delayedEnableButton = Future.delayed(const Duration(seconds: 5), () {});

      // Navigate to another screen while staying on the current screen
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(), // Replace with your screen
        ),
      );
    } catch (error) {
      print('Error saving order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while placing your order.'),
          duration: Duration(seconds: 3),
        ),
      );

      // Cancel the previous delayed future if it exists
      _delayedEnableButton = Future.delayed(const Duration(seconds: 5), () {});
    } finally {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the delayed future to avoid calling setState after dispose
    _delayedEnableButton = Future.value();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Place Order",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildOrderHistoryTable(),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => _saveOrderToFirestore(context),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        isButtonDisabled ? Colors.grey : Colors.deepPurple[300],
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
              ),
            ],
          ),
          if (isButtonDisabled)
            Container(
              color: Colors.black.withOpacity(0.6),
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderHistoryTable() {
    return Table(
      columnWidths: {0: const FixedColumnWidth(150.0)},
      border: TableBorder.all(color: Colors.grey),
      children: [
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
                child: Text(widget.selectedLocation),
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
                child: Text(widget.selectedCylinder),
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
                child: Text(widget.selectedQuantity),
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
                child: Text(widget.phoneNumber),
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
                child: Text(widget.sector),
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
                child: Text(widget.street),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.houseno),
            ),
          ),
        ]),
      ],
    );
  }
}
