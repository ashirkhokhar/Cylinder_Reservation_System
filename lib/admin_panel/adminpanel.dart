// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AdminPanel(),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  OrderSortType _currentSortType = OrderSortType.Ascending;

  void _toggleSortType() {
    setState(() {
      _currentSortType = _currentSortType == OrderSortType.Ascending
          ? OrderSortType.Descending
          : OrderSortType.Ascending;
    });
  }

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
          title: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              SizedBox(
                width: 40,
              ),
              Text(
                "Admin Panel",
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              Spacer(), // This will push the following widget to the end
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.lightbulb,
                      color: _currentSortType == OrderSortType.Ascending
                          ? Colors.yellow
                          : Colors.white,
                    ),
                    onPressed: _toggleSortType,
                  ),
                ],
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: AllOrdersList(currentSortType: _currentSortType),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[300],
          title: Text(
            "Logout Confirmation",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AllOrdersList extends StatefulWidget {
  final OrderSortType currentSortType;

  const AllOrdersList({
    Key? key,
    required this.currentSortType,
  }) : super(key: key);

  @override
  State<AllOrdersList> createState() => _AllOrdersListState();
}

enum OrderSortType {
  Ascending,
  Descending,
}

class _AllOrdersListState extends State<AllOrdersList> {
  late TextEditingController _searchController;
  String _searchText = "";
  List<String> _newOrders = [];
  late SharedPreferences _preferences;
  String _selectedStatus = "";
  OrderSortType _currentSortType = OrderSortType.Ascending; // Add this line

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    final newOrderIds = _preferences.getStringList('new_orders') ?? [];

    setState(() {
      _newOrders = newOrderIds;
    });
  }

  Future<void> _updateNewOrdersStatus() async {
    final allOrderIds = _newOrders;
    await _preferences.setStringList('new_orders', allOrderIds);
  }

  void _handleNewOrder(String orderDocumentId) async {
    // Update the order status in Firestore from 'New' to 'Pending'
    final orderRef = FirebaseFirestore.instance
        .collection('orderhistory')
        .doc(orderDocumentId);

    try {
      await orderRef.update({
        'status': 'Pending',
        'isNew': false, // Set isNew to false
      });

      setState(() {
        // Remove the order from the _newOrders list
        _newOrders.remove(orderDocumentId);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderDetailsScreen(orderDocumentId: orderDocumentId),
        ),
      );
    } catch (error) {
      print('Error updating order status: $error');
    }
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 60,
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
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
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

                if (widget.currentSortType == OrderSortType.Ascending) {
                  return timestampA.compareTo(timestampB);
                } else {
                  return timestampB.compareTo(timestampA);
                }
              });

              if (filteredOrders.isEmpty) {
                return const Text('No matching orders found');
              }

              return ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final orderData =
                      filteredOrders[index].data() as Map<String, dynamic>;
                  final orderDocumentId = filteredOrders[index].id;

                  final status = orderData['status'];
                  final isNewOrder = _newOrders.contains(orderDocumentId);

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: ListTile(
                          title: Text(
                            'Order ${index + 1}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'Location: ${orderData['selectedLocation']}',
                                style: GoogleFonts.poppins(),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Phone Number: ${orderData['phoneNumber']}',
                                style: GoogleFonts.poppins(),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Order Time: ${formatTime(parseOrderTimestamp(orderData['orderTimestamp']))}',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          trailing: status == 'New'
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    'New',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : status == 'Pending'
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[800],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        'Pending',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  : null,
                          onTap: () {
                            final orderDocumentId = filteredOrders[index].id;
                            _handleOrderTap(orderDocumentId);
                          },
                        ),
                      ));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleOrderTap(String orderDocumentId) async {
    await _markOrderAsPending(orderDocumentId);
  }

  Future<void> _markOrderAsPending(String orderDocumentId) async {
    final orderRef = FirebaseFirestore.instance
        .collection('orderhistory')
        .doc(orderDocumentId);

    try {
      await orderRef.update({
        'status': 'Pending',
        'isNew': false,
      });

      // Refresh the _newOrders list
      setState(() {
        _newOrders.remove(orderDocumentId);
      });
      _updateNewOrdersStatus();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderDetailsScreen(orderDocumentId: orderDocumentId),
        ),
      );
    } catch (error) {
      print('Error updating order status: $error');
    }
  }
}

class OrderDetailsScreen extends StatefulWidget {
  final String orderDocumentId;

  const OrderDetailsScreen({Key? key, required this.orderDocumentId})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          "Order Details",
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
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orderhistory')
                .doc(widget.orderDocumentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.deepPurple,
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('Order not found');
              }

              final orderData = snapshot.data!.data() as Map<String, dynamic>;

              return DataTable(
                columns: [
                  const DataColumn(label: Text('Field')),
                  const DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(
                      'Selected Location',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['selectedLocation'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Selected Cylinder',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['selectedCylinder'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Selected Quantity',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['selectedQuantity'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Sector',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['sector'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'House No',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['houseno'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Street',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['street'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Phone Number',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(
                      orderData['phoneNumber'],
                      style: GoogleFonts.poppins(),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Order Time',
                      style: GoogleFonts.poppins(),
                    )),
                    DataCell(Text(formatTime(
                        parseOrderTimestamp(orderData['orderTimestamp'])))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Order Status')),
                    DataCell(Text(
                      orderData['isNew'] ? 'New' : 'Pending',
                      style: GoogleFonts.poppins(),
                    )), // Update this line
                  ]),
                  // Add more data rows as needed
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

DateTime parseOrderTimestamp(Timestamp timestamp) {
  return timestamp.toDate();
}

String formatTime(DateTime dateTime) {
  return DateFormat('MMMM d, y h:mm:ss a').format(dateTime);
}
