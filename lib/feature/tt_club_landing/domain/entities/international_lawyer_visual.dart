import 'package:flutter/foundation.dart';

/// Visual model for the "International Lawyers" carousel.
///
/// Schema (recommended):
/// {
///   "id": "lawyer_001",
///   "name": "...",
///   "countryName": "...",
///   "countryCode": "EG",
///   "photoAsset": "assets/images/...",
///   "flagAsset": "assets/images/flags/eg.png", // optional if you rely on countryCode
///   "specialty": "..." // optional
/// }
@immutable
class InternationalLawyerVisual {
  final String id;
  final String name;
  final String countryName;
  final String? countryCode;

  /// Circular photo.
  final String photoAsset;

  /// Small flag badge.
  final String? flagAsset;

  final String? specialty;

  const InternationalLawyerVisual({
    required this.id,
    required this.name,
    required this.countryName,
    required this.photoAsset,
    this.countryCode,
    this.flagAsset,
    this.specialty,
  });

  factory InternationalLawyerVisual.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final photoAsset = json['photoAsset'];

    if (id is! String || photoAsset is! String) {
      throw const FormatException('Invalid international lawyers json schema');
    }

    // Backward compatible defaults.
    final name = (json['name'] is String) ? json['name'] as String : '';
    final countryName =
        (json['countryName'] is String) ? json['countryName'] as String : '';

    final countryCode = (json['countryCode'] is String)
        ? (json['countryCode'] as String)
        : null;

    // Optional explicit flag.
    final flagAsset =
        (json['flagAsset'] is String) ? json['flagAsset'] as String : null;

    final specialty =
        (json['specialty'] is String) ? json['specialty'] as String : null;

    return InternationalLawyerVisual(
      id: id,
      name: name,
      countryName: countryName,
      countryCode: countryCode,
      photoAsset: photoAsset,
      flagAsset: flagAsset,
      specialty: specialty,
    );
  }
}
