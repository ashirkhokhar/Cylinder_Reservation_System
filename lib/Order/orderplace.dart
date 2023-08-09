// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Details/OrderDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Orderplace extends StatefulWidget {
  final String selectedCylinder;
  final String cylinderSize;
  final String selectedQuantity;

  const Orderplace({
    Key? key,
    required this.selectedCylinder,
    required this.cylinderSize,
    required this.selectedQuantity,
  }) : super(key: key);

  @override
  State<Orderplace> createState() => _OrderplaceState();
}

class _OrderplaceState extends State<Orderplace> {
  final String sessionId = const Uuid().v4();
  final sectorcontroller = TextEditingController();
  final streetcontroller = TextEditingController();
  final housenocontroller = TextEditingController();
  final phonenocontroller = TextEditingController();
  String _phoneNumberError = ''; // Add this controller
  String _selectedLocation = 'Bahria Enclave';
  bool _isLoading = false; // Flag to track loading state

  bool _validateFields() {
    return sectorcontroller.text.isNotEmpty &&
        streetcontroller.text.isNotEmpty &&
        housenocontroller.text.isNotEmpty &&
        phonenocontroller.text.isNotEmpty &&
        (phonenocontroller.text.length == 10 ||
            phonenocontroller.text.length == 11); // Check for 10 or 11 digits
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Proceed With Order",
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
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Please let us know about your location:'),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = 'Bahria Enclave';
                        });
                      },
                      child: ListTile(
                        leading: Radio<String>(
                          value: 'Bahria Enclave',
                          groupValue: _selectedLocation,
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value!;
                            });
                          },
                        ),
                        title: const Text('Bahria Enclave'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = 'Park View';
                        });
                      },
                      child: ListTile(
                        leading: Radio<String>(
                          value: 'Park View',
                          groupValue: _selectedLocation,
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value!;
                            });
                          },
                        ),
                        title: const Text('Park View'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: sectorcontroller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Sector',
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: streetcontroller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Street',
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: housenocontroller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'Enter House No / Apartment No. and Building Details',
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: phonenocontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Phone Number',
                              errorText: _phoneNumberError.isNotEmpty
                                  ? _phoneNumberError
                                  : null,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            maxLength: 11, // Maximum length allowed
                            onChanged: (value) {
                              // Update error message based on input length
                              if (value.length < 10) {
                                // Changed to 10 digits
                                setState(() {
                                  _phoneNumberError =
                                      'Phone number should be at least 10 digits'; // Changed message
                                });
                              } else if (value.length > 11) {
                                // Changed to 11 digits
                                setState(() {
                                  _phoneNumberError =
                                      'Phone number should not exceed 11 digits';
                                });
                              } else {
                                setState(() {
                                  _phoneNumberError = '';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: AbsorbPointer(
                        absorbing: _isLoading,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            if (_validateFields()) {
                              String selectedLocation = _selectedLocation;
                              String sector = sectorcontroller.text;
                              String street = streetcontroller.text;
                              String houseNo = housenocontroller.text;
                              String phoneNumber = phonenocontroller.text;

                              // Delay showing the circular progress indicator for 2 seconds
                              await Future.delayed(Duration(seconds: 2));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    selectedLocation: selectedLocation,
                                    selectedCylinder: widget.selectedCylinder,
                                    selectedQuantity: widget.selectedQuantity,
                                    sector: sector,
                                    street: street,
                                    houseNo: houseNo,
                                    phoneNumber: phoneNumber,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please fill all the required data to proceed with the order",
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }

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
                                'Submit',
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
                  ]),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
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
