class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {}; // Lấy thông tin user từ API
    return User(
      id: userJson['_id'] ?? '',
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      role: userJson['role'] ?? 'user',
      avatar:
          userJson['avatar'] ?? '', // Nếu avatar không có, trả về chuỗi rỗng
      token: json['token'] ?? '', // Token nằm ngoài object "user"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        '_id': id,
        'name': name,
        'email': email,
        'role': role,
        'avatar': avatar,
      },
      'token': token,
    };
  }
}
