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
  bool _isLoading = false;
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
      setState(() {
        _isLoading = true;
      });

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

      // Simulate a delay to demonstrate success and reset state
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your order has been placed successfully!',
            style: GoogleFonts.poppins(),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to another screen while staying on the current screen
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
    } finally {
      setState(() {
        isButtonDisabled = false;
        _isLoading = false;
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
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepPurple[300]),
                  child: Center(
                    child: _isLoading
                        ? Container(
                            width: 24, // Adjust the size as needed
                            height: 24,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Place Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
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
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(' Location:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(widget.selectedLocation, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Cylinder:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(widget.selectedCylinder, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Quantity:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(widget.selectedQuantity, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Phone Number:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.phoneNumber, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Sector:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.sector, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Street:', style: GoogleFonts.poppins()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.street, style: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
        TableRow(children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('House No:', style: GoogleFonts.poppins()),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.houseno, style: GoogleFonts.poppins()),
            ),
          ),
        ]),
      ],
    );
  }
}
