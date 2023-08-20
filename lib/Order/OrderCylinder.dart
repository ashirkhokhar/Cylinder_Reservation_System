// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Order/orderplace.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCylinder extends StatefulWidget {
  const OrderCylinder({Key? key}) : super(key: key);

  @override
  State<OrderCylinder> createState() => _OrderCylinderState();
}

class _OrderCylinderState extends State<OrderCylinder> {
  String _selectedCylindersize = 'Small – 11 KGs';
  String _selectedQuantity = 'One'; // To store the selected quantity
  bool _isLoading = false;

  List<String> quantityOptions = ['One', 'Two', 'Three', 'Four', 'Five'];

  Future<void> _showQuantityDialog() async {
    String? selectedQuantity = await showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent the dialog from being dismissed by tapping outside
      builder: (BuildContext dialogContext) {
        String selectedValue = _selectedQuantity; // Default selected value
        return AlertDialog(
          title: Text(
            'Select Quantity',
            style: GoogleFonts.poppins(
              fontSize: 20,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      dropdownColor: Colors
                          .deepPurple[300], // Set the color of the dropdown
                      style: GoogleFonts.poppins(),
                      // Dropdown text style
                      underline: Container(),
                      icon: Icon(
                        Icons
                            .arrow_drop_down, // Change the icon to a different one if desired
                        color: Colors.white, // Change the icon color here
                      ), // Remove dropdown underline
                      items: quantityOptions.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(value),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[300],
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (selectedValue.isNotEmpty) {
                                Navigator.pop(dialogContext, selectedValue);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a quantity.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple[300],
                            ),
                            child: Text(
                              'OK',
                              style: GoogleFonts.poppins(),
                            )),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedQuantity != null) {
      setState(() {
        _selectedQuantity = selectedQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          "Order Cylinder",
          style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white),
        ),
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
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Text(
                  'Please let us know which cylinder do you want:',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCylindersize = 'Small – 11 KGs';
                      _showQuantityDialog();
                    });
                  },
                  child: ListTile(
                    leading: Radio<String>(
                      value: 'Small – 11 KGs',
                      groupValue: _selectedCylindersize,
                      onChanged: (value) {
                        setState(() {
                          _selectedCylindersize = value!;
                          _showQuantityDialog();
                        });
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    title: Text(
                      'Small – 11 KGs${_selectedCylindersize == 'Small – 11 KGs' ? ' ($_selectedQuantity)' : ''}',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCylindersize = 'Large – 45 KGs';
                      _showQuantityDialog();
                    });
                  },
                  child: ListTile(
                    leading: Radio<String>(
                      value: 'Large – 45 KGs',
                      groupValue: _selectedCylindersize,
                      onChanged: (value) {
                        setState(() {
                          _selectedCylindersize = value!;
                          _showQuantityDialog();
                        });
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    title: Text(
                      'Large – 45 KGs${_selectedCylindersize == 'Large – 45 KGs' ? ' ($_selectedQuantity)' : ''}',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _selectedQuantity.isNotEmpty
                    ? Text(
                        'Selected: $_selectedCylindersize ($_selectedQuantity)',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      )
                    : const Text(
                        'Please select a quantity.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Orderplace(
                            selectedCylinder: _selectedCylindersize,
                            selectedQuantity: _selectedQuantity,
                            cylinderSize: '',
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
