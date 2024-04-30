class Contact {
  final String name;
  final String phoneNumber;

  Contact(this.name, this.phoneNumber);

  @override
  String toString() {
    return 'Contact(name: $name, phoneNumber: $phoneNumber);';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['name'],
      json['number'],
    );
  }
}
