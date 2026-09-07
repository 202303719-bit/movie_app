class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String avatar; // asset path or URL, e.g. 'assets/images/avatar_1.png'

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatar: map['avatar'] ?? 'assets/images/avatar_1.png',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }
}
