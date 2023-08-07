// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Order/orderplace.dart';
import 'package:google_fonts/google_fonts.dart';

class Quantity extends StatefulWidget {
  const Quantity({Key? key, required this.selectedCylinder}) : super(key: key);

  final String selectedCylinder;

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  final List<String> _animals = ["one", "two", "three", "four", "five"];
  String? _selectedAnimal;
  String _selectedCylindersize = 'Small – 11 KGs';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Quantity",
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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedAnimal,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnimal = value;
                      });
                    },
                    hint: const Center(
                      child: Text(
                        'Select Quantity (1-5)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    underline: Container(),
                    // Change the dropdown color here
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    isExpanded: true,
                    items: _animals
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    selectedItemBuilder: (BuildContext context) => _animals
                        .map(
                          (e) => Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true; // Show circular progress indicator
                      });

                      await Future.delayed(Duration(seconds: 2));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Orderplace(
                            selectedCylinder: widget.selectedCylinder,
                            cylinderSize: _selectedCylindersize,
                            selectedQuantity: _selectedAnimal ?? "one",
                          ),
                        ),
                      );

                      setState(() {
                        _isLoading = false; // Hide circular progress indicator
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
