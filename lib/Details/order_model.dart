class OrderData {
  final String selectedLocation;
  final String selectedCylinder;
  final String selectedQuantity;
  final String sector;
  final String street;
  final String houseNo;
  final String phoneNumber;
  // Add this field

  OrderData({
    required this.selectedLocation,
    required this.selectedCylinder,
    required this.selectedQuantity,
    required this.sector,
    required this.street,
    required this.houseNo,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedLocation': selectedLocation,
      'selectedCylinder': selectedCylinder,
      'selectedQuantity': selectedQuantity,
      'sector': sector,
      'street': street,
      'houseNo': houseNo,
      'phoneNumber': phoneNumber,
    };
  }

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      selectedLocation: json['selectedLocation'] ?? '',
      selectedCylinder: json['selectedCylinder'] ?? '',
      selectedQuantity: json['selectedQuantity'] ?? '',
      sector: json['sector'] ?? '',
      street: json['street'] ?? '',
      houseNo: json['houseNo'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
