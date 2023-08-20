// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Details/OrderTable.dart';
import 'package:flutter_application_1/Details/order_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'order_model.dart';

class DetailsPage extends StatefulWidget {
  final String selectedLocation;
  final String selectedCylinder;
  final String selectedQuantity; // New variable for cylinder size
  final String sector;
  final String street;
  final String houseNo;
  final String phoneNumber;

  DetailsPage({
    required this.selectedLocation,
    required this.selectedCylinder,
    required this.selectedQuantity,
    required this.sector,
    required this.street,
    required this.houseNo,
    required this.phoneNumber,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Selected Credentials",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: [
                ListTile(
                  title: Text('Location', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.selectedLocation,
                      style: GoogleFonts.poppins()),
                ),
                ListTile(
                  title: Text('Cylinder', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.selectedCylinder,
                      style: GoogleFonts.poppins()),
                ),
                ListTile(
                  title: Text('Quantity', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.selectedQuantity,
                      style: GoogleFonts.poppins()),
                ),
                ListTile(
                  title: Text('Sector', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.sector, style: GoogleFonts.poppins()),
                ),
                ListTile(
                  title: Text('Street', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.street, style: GoogleFonts.poppins()),
                ),
                ListTile(
                  title: Text('House No', style: GoogleFonts.poppins()),
                  subtitle: Text(widget.houseNo, style: GoogleFonts.poppins()),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      orderProvider.addOrder(OrderData(
                        selectedLocation: widget.selectedLocation,
                        selectedCylinder: widget.selectedCylinder,
                        selectedQuantity: widget.selectedQuantity,
                        sector: widget.sector,
                        houseNo: widget.houseNo,
                        street: widget.street,
                        phoneNumber: widget.phoneNumber,

                        // Set the actual timestamp value here
                      ));

                      await Future.delayed(
                          const Duration(seconds: 2)); // Simulate some process

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ordertable(
                            selectedLocation: widget.selectedLocation,
                            selectedCylinder: widget.selectedCylinder,
                            selectedQuantity: widget.selectedQuantity,
                            phoneNumber: widget.phoneNumber,
                            sector: widget.sector,
                            houseno: widget.houseNo,
                            street: widget.street,
                          ),
                        ),
                      );

                      setState(() {
                        _isLoading = false;
                      });
                    },
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
                                height: 24, // Adjust the size as needed
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
