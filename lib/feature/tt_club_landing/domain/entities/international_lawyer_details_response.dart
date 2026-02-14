import 'package:flutter/foundation.dart';
import 'international_lawyer_provider.dart';

/// Model for booking overview statistics
@immutable
class BookingOverview {
  final String bookingStatus;
  final int total;

  const BookingOverview({
    required this.bookingStatus,
    required this.total,
  });

  factory BookingOverview.fromJson(Map<String, dynamic> json) {
    return BookingOverview(
      bookingStatus: json['booking_status'] as String? ?? '',
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_status': bookingStatus,
      'total': total,
    };
  }
}

/// Response model for individual international lawyer provider details
@immutable
class InternationalLawyerDetailsResponse {
  final InternationalLawyerProvider providerInfo;
  final List<BookingOverview> bookingOverview;

  const InternationalLawyerDetailsResponse({
    required this.providerInfo,
    required this.bookingOverview,
  });

  factory InternationalLawyerDetailsResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;
    final providerData = content?['provider_info'] as Map<String, dynamic>?;
    final bookingData = content?['booking_overview'] as List<dynamic>? ?? [];

    return InternationalLawyerDetailsResponse(
      providerInfo: providerData != null
          ? InternationalLawyerProvider.fromJson(providerData)
          : const InternationalLawyerProvider(
              id: '',
              providerCategory: '',
              isApproved: 0,
            ),
      bookingOverview: bookingData
          .map((e) => BookingOverview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': {
        'provider_info': providerInfo.toJson(),
        'booking_overview': bookingOverview.map((e) => e.toJson()).toList(),
      },
    };
  }
}

