// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _showLogoutConfirmationDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[300],
          title: Text("Admin Panel",
              style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          )),

          // ... (existing app bar code)
        ),
        body: const AllOrdersList(),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout Confirmation"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                // For example: Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context)
                    .pop(true); // Return true to allow back navigation
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

// ... (other code remains the same)

class AllOrdersList extends StatefulWidget {
  const AllOrdersList({super.key});

  @override
  State<AllOrdersList> createState() => _AllOrdersListState();
}

class _AllOrdersListState extends State<AllOrdersList> {
  late TextEditingController _searchController;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTime parseOrderTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('MMMM d, y h:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 60, // Fixed height for the search bar
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Location or Phone Number',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.deepPurple[300],
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchText = "";
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orderhistory')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: const CircularProgressIndicator(
                  color: Colors.deepPurple,
                ));
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No Orders Found');
              }

              final filteredOrders = snapshot.data!.docs.where((doc) {
                final orderData = doc.data() as Map<String, dynamic>;
                final selectedLocation =
                    orderData['selectedLocation'] as String;
                final phoneNumber = orderData['phoneNumber'] as String;

                return selectedLocation
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()) ||
                    phoneNumber.contains(_searchText);
              }).toList();

              filteredOrders.sort((a, b) {
                final timestampA =
                    parseOrderTimestamp(a['orderTimestamp'] as Timestamp);
                final timestampB =
                    parseOrderTimestamp(b['orderTimestamp'] as Timestamp);
                return timestampA.compareTo(timestampB);
              });

              if (filteredOrders.isEmpty) {
                return const Text('No matching orders found');
              }

              return ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final orderData =
                      filteredOrders[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: ListTile(
                        tileColor: Colors.deepPurple[300],
                        title: Text(
                          'Order ${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              'Location: ${orderData['selectedLocation']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Phone Number: ${orderData['phoneNumber']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Order Time: ${formatTime(parseOrderTimestamp(orderData['orderTimestamp']))}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(orderData: orderData),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text("Order Details",
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Field')),
              const DataColumn(label: Text('Value')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Selected Location')),
                DataCell(Text(orderData['selectedLocation'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Selected Cylinder')),
                DataCell(Text(orderData['selectedCylinder'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Selected Quantity')),
                DataCell(Text(orderData['selectedQuantity'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Sector')),
                DataCell(Text(orderData['sector'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('House No')),
                DataCell(Text(orderData['houseno'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Street')),
                DataCell(Text(orderData['street'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Phone Number')),
                DataCell(Text(orderData['phoneNumber'])),
              ]),
              DataRow(cells: [
                const DataCell(Text('Order Time')),
                DataCell(Text(formatTime(
                    parseOrderTimestamp(orderData['orderTimestamp'])))),
              ]),

              // Add more data rows as needed
            ],
          ),
        ),
      ),
    );
  }

  DateTime parseOrderTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}

String formatTime(DateTime dateTime) {
  return DateFormat('MMMM d, y h:mm:ss a').format(dateTime);
}
