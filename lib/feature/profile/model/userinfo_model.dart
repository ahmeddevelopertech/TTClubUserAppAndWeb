import 'package:demandium/feature/booking/model/booking_details_model.dart';

class UserInfoModel {
  String? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? imageFullPath;
  String? phone;
  String? password;
  String? confirmPassword;
  String? createdAt;
  int? bookingsCount;
  String? referCode;
  String? referredBy;
  int? isEmailVerified;
  int? isPhoneVerified;
  double? walletBalance;
  String? userType;
  BookingDetailsContent? lastIncompleteOfflineBooking;


  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.imageFullPath,
        this.phone,
        this.password,
        this.confirmPassword,
        this.createdAt,
        this.bookingsCount,
        this.referCode,
        this.referredBy,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.walletBalance,
        this.userType,
        this.lastIncompleteOfflineBooking,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['first_name'];
    lName = json['last_name'];
    email = json['email'];
    image = json['profile_image'];
    imageFullPath = json['profile_image_full_path'];
    phone = json['phone'];
    createdAt = json['created_at'];
    referCode = json['ref_code'];
    referredBy = json['referred_by'];
    userType = json['user_type'];
    bookingsCount =  int.tryParse(json['bookings_count'].toString());
    isEmailVerified =  int.tryParse(json['is_email_verified'].toString());
    isPhoneVerified =  int.tryParse(json['is_phone_verified'].toString());
    walletBalance =  double.tryParse(json['wallet_balance'].toString());
    lastIncompleteOfflineBooking = json['last_incomplete_offline_booking'] != null
        ? BookingDetailsContent.fromJson(json['last_incomplete_offline_booking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = fName;
    data['last_name'] = lName;
    data['email'] = email;
    data['profile_image'] = image;
    data['profile_image_full_path'] = imageFullPath;
    data['phone'] = phone;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['ref_code'] = referCode;
    data['referred_by'] = referredBy;
    return data;
  }

  /// Get full name with user type
  /// Example: "Ahmed Mohamed (محامي)"
  String get fullNameWithType {
    final name = '${fName ?? ''} ${lName ?? ''}'.trim();
    final typeDisplay = _getUserTypeDisplay(userType);
    return typeDisplay.isEmpty ? name : '$name $typeDisplay';
  }

  /// Get full name without type
  String get fullName {
    return '${fName ?? ''} ${lName ?? ''}'.trim();
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
