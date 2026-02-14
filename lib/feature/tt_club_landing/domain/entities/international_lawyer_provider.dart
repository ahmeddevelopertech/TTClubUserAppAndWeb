import 'package:flutter/foundation.dart';

/// Model for individual international lawyer provider from API
@immutable
class InternationalLawyerProvider {
  final String id;
  final String providerCategory;
  final int isApproved; // 0=pending, 1=approved, 2=denied
  final ProviderOwner? owner;
  final ProviderZone? zone;

  const InternationalLawyerProvider({
    required this.id,
    required this.providerCategory,
    required this.isApproved,
    this.owner,
    this.zone,
  });

  factory InternationalLawyerProvider.fromJson(Map<String, dynamic> json) {
    return InternationalLawyerProvider(
      id: json['id'] as String? ?? '',
      providerCategory: json['provider_category'] as String? ?? '',
      isApproved: json['is_approved'] as int? ?? 0,
      owner: json['owner'] != null ? ProviderOwner.fromJson(json['owner'] as Map<String, dynamic>) : null,
      zone: json['zone'] != null ? ProviderZone.fromJson(json['zone'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_category': providerCategory,
      'is_approved': isApproved,
      'owner': owner?.toJson(),
      'zone': zone?.toJson(),
    };
  }
}

/// Model for provider owner information
@immutable
class ProviderOwner {
  final String id;
  final Account? account;

  const ProviderOwner({
    required this.id,
    this.account,
  });

  factory ProviderOwner.fromJson(Map<String, dynamic> json) {
    return ProviderOwner(
      id: json['id'] as String? ?? '',
      account: json['account'] != null ? Account.fromJson(json['account'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account?.toJson(),
    };
  }
}

/// Model for provider account details
@immutable
class Account {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const Account({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
    };
  }
}

/// Model for provider zone information
@immutable
class ProviderZone {
  final String? id;
  final String? name;
  final String? countryCode;

  const ProviderZone({
    this.id,
    this.name,
    this.countryCode,
  });

  factory ProviderZone.fromJson(Map<String, dynamic> json) {
    return ProviderZone(
      id: json['id'] as String?,
      name: json['name'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country_code': countryCode,
    };
  }
}

