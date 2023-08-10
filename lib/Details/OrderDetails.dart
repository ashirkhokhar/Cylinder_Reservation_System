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
                  title: const Text('Location'),
                  subtitle: Text(widget.selectedLocation),
                ),
                ListTile(
                  title: const Text('Cylinder'),
                  subtitle: Text(widget.selectedCylinder),
                ),
                ListTile(
                  title: const Text('Quantity'),
                  subtitle: Text(widget.selectedQuantity),
                ),
                ListTile(
                  title: const Text('Sector'),
                  subtitle: Text(widget.sector),
                ),
                ListTile(
                  title: const Text('Street'),
                  subtitle: Text(widget.street),
                ),
                ListTile(
                  title: const Text('House No'),
                  subtitle: Text(widget.houseNo),
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
                      width: 300,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
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
}
