class Contact {
  final String name;
  final String phoneNumber;
  final String tgUsername;
  String? chatId;

  Contact({
    required this.name,
    required this.phoneNumber,
    this.tgUsername = '',
    this.chatId,
  });

  @override
  String toString() {
    return 'Contact(name: $name, phoneNumber: $phoneNumber, tgUsername: $tgUsername, chatId: $chatId)';
  }

  // convert a Contact to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'tgUsername': tgUsername,
        'chatId': chatId,
      };

  // create a Contact from JSON
  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        tgUsername: json['tgUsername'] ?? '',
        chatId: json['chatId'],
      );

  Contact copyWith({
    String? name,
    String? phoneNumber,
    String? tgUsername,
    String? chatId,
  }) {
    return Contact(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tgUsername: tgUsername ?? this.tgUsername,
      chatId: chatId ?? this.chatId,
    );
  }
}
