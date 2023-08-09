// ignore_for_file: use_build_context_synchronously

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
          title: const Text(
            'Select Quantity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
                      dropdownColor:
                          Colors.white, // Set the color of the dropdown
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
                            primary: Colors.deepPurple[300],
                          ),
                          child: const Text('Cancel'),
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
                          child: const Text('OK'),
                        ),
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
                const Text(
                  'Please let us know which cylinder do you want:',
                  style: TextStyle(fontSize: 18),
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
                    ),
                    title: Text(
                      'Small – 11 KGs${_selectedCylindersize == 'Small – 11 KGs' ? ' ($_selectedQuantity)' : ''}',
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
                    ),
                    title: Text(
                      'Large – 45 KGs${_selectedCylindersize == 'Large – 45 KGs' ? ' ($_selectedQuantity)' : ''}',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _selectedQuantity.isNotEmpty
                    ? Text(
                        'Selected: $_selectedCylindersize ($_selectedQuantity)',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}
