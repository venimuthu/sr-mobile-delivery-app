/// A saved delivery address.
class Address {
  final String id;
  final String label; // "Home", "Work"
  final String line1;
  final String line2;
  final String city;
  final String pincode;

  const Address({
    required this.id,
    required this.label,
    required this.line1,
    required this.line2,
    required this.city,
    required this.pincode,
  });

  String get oneLine => '$line1, $line2, $city - $pincode';

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as String,
        label: json['label'] as String,
        line1: json['line1'] as String,
        line2: (json['line2'] ?? '') as String,
        city: json['city'] as String,
        pincode: json['pincode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'line1': line1,
        'line2': line2,
        'city': city,
        'pincode': pincode,
      };
}

/// The signed-in customer.
class AppUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final List<Address> addresses;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.addresses = const [],
  });

  Address? get primaryAddress =>
      addresses.isEmpty ? null : addresses.first;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: (json['email'] ?? '') as String,
        addresses: (json['addresses'] as List?)
                ?.map((a) => Address.fromJson(a as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'addresses': addresses.map((a) => a.toJson()).toList(),
      };
}
