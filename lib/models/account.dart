class Account {
  final String email;
  final String token;
  final int userId;
  final String userName;
  final String societyName;  // NEW
  final String baseUrl;      // NEW

  Account({
    required this.email,
    required this.token,
    required this.userId,
    required this.userName,
    required this.societyName,  // NEW
    required this.baseUrl,      // NEW
  });

  // Convert Account to JSON
  Map<String, dynamic> toJson() => {
    'email': email,
    'token': token,
    'userId': userId,
    'userName': userName,
    'societyName': societyName,  // NEW
    'baseUrl': baseUrl,          // NEW
  };

  // Create Account from JSON
  factory Account.fromJson(Map<String, dynamic> json) => Account(
    email: json['email'] ?? '',
    token: json['token'] ?? '',
    userId: json['userId'] ?? 0,
    userName: json['userName'] ?? '',
    societyName: json['societyName'] ?? '',  // NEW
    baseUrl: json['baseUrl'] ?? '',          // NEW
  );
}