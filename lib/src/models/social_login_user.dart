/// User information from social login providers
class SocialLoginUser {
  /// User's unique identifier from the provider
  final String id;
  
  /// User's display name
  final String? name;
  
  /// User's email address
  final String? email;
  
  /// URL to user's profile photo
  final String? photoUrl;
  
  /// Additional user data from the provider
  final Map<String, dynamic>? additionalData;

  const SocialLoginUser({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.additionalData,
  });

  /// Creates a copy of this user with updated values
  SocialLoginUser copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return SocialLoginUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  /// Converts the user to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'additionalData': additionalData,
    };
  }

  /// Creates a user from a map
  factory SocialLoginUser.fromMap(Map<String, dynamic> map) {
    return SocialLoginUser(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      additionalData: map['additionalData'],
    );
  }

  @override
  String toString() {
    return 'SocialLoginUser(id: $id, name: $name, email: $email, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SocialLoginUser &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        photoUrl.hashCode;
  }
}