import 'package:flutter/material.dart';
import 'package:flutter_application_1/Details/OrderTable.dart';
import 'package:flutter_application_1/Details/order_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'order_model.dart';

class DetailsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Selected Credenstials",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          children: [
            ListTile(
              title: const Text('Location'),
              subtitle: Text(selectedLocation),
            ),
            ListTile(
              title: const Text('Cylinder'),
              subtitle: Text(selectedCylinder),
            ),
            ListTile(
              title: const Text('Quantity'),
              subtitle: Text(selectedQuantity),
            ),
            ListTile(
              title: const Text('Sector'),
              subtitle: Text(sector),
            ),
            ListTile(
              title: const Text('Street'),
              subtitle: Text(street),
            ),
            ListTile(
              title: const Text('House No'),
              subtitle: Text(houseNo),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: () {
                  orderProvider.addOrder(OrderData(
                    selectedLocation: selectedLocation,
                    selectedCylinder: selectedCylinder,
                    selectedQuantity:
                        selectedQuantity, // Make sure you have this field
                    sector: sector, // Make sure you have this field
                    houseNo: houseNo, // Make sure you have this field
                    street: street, // Make sure you have this field
                    phoneNumber: phoneNumber,
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Ordertable(
                        selectedLocation: selectedLocation,
                        selectedCylinder: selectedCylinder,
                        selectedQuantity: selectedQuantity,
                        phoneNumber: phoneNumber,
                        sector: sector,
                        houseno: houseNo,
                        street: street,
                      ),
                    ),
                  );
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
    );
  }
}
