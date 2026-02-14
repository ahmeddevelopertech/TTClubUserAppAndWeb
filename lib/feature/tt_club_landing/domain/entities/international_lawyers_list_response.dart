import 'package:flutter/foundation.dart';
import 'international_lawyer_provider.dart';

/// Response model for international lawyers list
@immutable
class InternationalLawyersListResponse {
  final List<InternationalLawyerProvider> providers;
  final int currentPage;
  final int onboardingCount;
  final int deniedCount;

  const InternationalLawyersListResponse({
    required this.providers,
    required this.currentPage,
    required this.onboardingCount,
    required this.deniedCount,
  });

  factory InternationalLawyersListResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;
    final providersData = content?['providers'] as Map<String, dynamic>?;
    final providersList = providersData?['data'] as List<dynamic>? ?? [];

    return InternationalLawyersListResponse(
      providers: providersList
          .map((e) => InternationalLawyerProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (providersData?['current_page'] as int?) ?? 1,
      onboardingCount: (content?['onboarding_count'] as int?) ?? 0,
      deniedCount: (content?['denied_count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': {
        'providers': {
          'current_page': currentPage,
          'data': providers.map((e) => e.toJson()).toList(),
        },
        'onboarding_count': onboardingCount,
        'denied_count': deniedCount,
      },
    };
  }
}

