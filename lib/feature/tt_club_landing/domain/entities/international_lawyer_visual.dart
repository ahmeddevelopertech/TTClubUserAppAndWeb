import 'package:flutter/foundation.dart';

@immutable
class InternationalLawyerVisual {
  final String id;

  /// Circular photo of the lawyer.
  final String photoAsset;

  /// Card image that contains the country flag + country name + lawyer name.
  final String cardAsset;

  const InternationalLawyerVisual({
    required this.id,
    required this.photoAsset,
    required this.cardAsset,
  });

  factory InternationalLawyerVisual.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final photoAsset = json['photoAsset'];
    final cardAsset = json['cardAsset'];

    if (id is! String || photoAsset is! String || cardAsset is! String) {
      throw const FormatException('Invalid international lawyers json schema');
    }

    return InternationalLawyerVisual(
      id: id,
      photoAsset: photoAsset,
      cardAsset: cardAsset,
    );
  }
}
