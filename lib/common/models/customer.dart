class Customer {
  String? id;
  String? roleId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? identificationNumber;
  String? identificationType;
  String? gender;
  String? profileImage;
  String? profileImageFullPath;
  int? isPhoneVerified;
  int? isEmailVerified;
  int? isActive;
  String? userType;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
        this.roleId,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.identificationNumber,
        this.identificationType,
        this.gender,
        this.profileImage,
        this.profileImageFullPath,
        this.isPhoneVerified,
        this.isEmailVerified,
        this.isActive,
        this.userType,
        this.createdAt,
        this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    identificationNumber = json['identification_number'];
    identificationType = json['identification_type'];
    gender = json['gender'];
    profileImage = json['profile_image'];
    profileImageFullPath = json['profile_image_full_path'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    isActive = json['is_active'];
    userType = json['user_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_id'] = roleId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['identification_number'] = identificationNumber;
    data['identification_type'] = identificationType;
    data['gender'] = gender;
    data['profile_image'] = profileImage;
    data['profile_image_full_path'] = profileImageFullPath;
    data['is_phone_verified'] = isPhoneVerified;
    data['is_email_verified'] = isEmailVerified;
    data['is_active'] = isActive;
    data['user_type'] = userType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  /// Get full name with user type
  /// Example: "Ahmed Mohamed (محامي)"
  String get fullNameWithType {
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    final typeDisplay = _getUserTypeDisplay(userType);
    return typeDisplay.isEmpty ? name : '$name $typeDisplay';
  }

  /// Get full name without type
  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  /// Convert user type to readable format
  static String _getUserTypeDisplay(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'lawyers':
        return '(محامي)';
      case 'companies':
        return '(شركة)';
      case 'individuals_membership':
        return '(عضو)';
      case 'club_delegate':
        return '(منتدب نادي)';
      case 'legal_sponsorship':
        return '(رعاية قانونية)';
      default:
        return '';
    }
  }
}