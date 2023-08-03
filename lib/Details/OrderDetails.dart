import 'package:flutter/material.dart';
import 'package:flutter_application_1/Order/OrderCylinder.dart';

class DetailsPage extends StatelessWidget {
  final String selectedLocation;
  final String selectedCylinder;
  final String selectedQuantity; // New variable for cylinder size
  final String sector;
  final String street;
  final String houseNo;

  DetailsPage({
    required this.selectedLocation,
    required this.selectedCylinder,
    required this.selectedQuantity,
    required this.sector,
    required this.street,
    required this.houseNo,
    required String phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Text('Order Details'),
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
            // ListTile(
            //   title: Text('Cylinder Size'),
            //   subtitle: Text(cylinderSize),
            // ),
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
                  // Show a snackbar to indicate that the order has been placed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your order has been placed!'),
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
                  child: Center(
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
