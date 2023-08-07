import 'package:flutter/material.dart';
import 'package:flutter_application_1/Quantity.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCylinder extends StatefulWidget {
  const OrderCylinder({Key? key}) : super(key: key);

  @override
  State<OrderCylinder> createState() => _OrderCylinderState();
}

class _OrderCylinderState extends State<OrderCylinder> {
  String _selectedCylindersize = 'Small – 11 KGs';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Order Cylinder",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please let us know which cylinder do you want:',
                  style: TextStyle(fontSize: 18),
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'Small – 11 KGs',
                    groupValue: _selectedCylindersize,
                    onChanged: (value) {
                      setState(() {
                        _selectedCylindersize = value!;
                      });
                    },
                  ),
                  title: const Text('Small – 11 KGs'),
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'Large – 45 KGs',
                    groupValue: _selectedCylindersize,
                    onChanged: (value) {
                      setState(() {
                        _selectedCylindersize = value!;
                      });
                    },
                  ),
                  title: const Text('Large – 45 KGs'),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true; // Show circular progress indicator
                      });

                      // Simulate a delay to demonstrate the loading state
                      await Future.delayed(Duration(seconds: 2));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Quantity(
                            selectedCylinder: _selectedCylindersize,
                          ),
                        ),
                      );

                      setState(() {
                        _isLoading = false; // Hide circular progress indicator
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Next',
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
          // Show circular progress indicator when _isLoading is true
          if (_isLoading)
            Container(
              color: Colors.black45, // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(color: Colors.deepPurple[300]),
              ),
            ),
        ],
      ),
    );
  }
}
