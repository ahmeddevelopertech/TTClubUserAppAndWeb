// Quick Testing Guide for Admin Lawyers APIs

// ============================================================
// FILE: test/features/tt_club_landing/admin_lawyers_test.dart
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:demandium/feature/tt_club_landing/domain/entities/international_lawyer_provider.dart';
import 'package:demandium/feature/tt_club_landing/domain/entities/international_lawyers_list_response.dart';
import 'package:demandium/feature/tt_club_landing/domain/entities/international_lawyer_details_response.dart';
import 'package:demandium/feature/tt_club_landing/data/datasources/international_lawyers_admin_remote_datasource.dart';
import 'package:demandium/feature/tt_club_landing/domain/repositories/international_lawyers_admin_repository.dart';
import 'package:demandium/feature/tt_club_landing/domain/usecases/get_international_lawyers_list_usecase.dart';
import 'package:demandium/feature/tt_club_landing/domain/usecases/get_international_lawyer_details_usecase.dart';

void main() {
  group('International Lawyers Admin APIs', () {
    
    // ============================================================
    // Test 1: Get International Lawyers List
    // ============================================================
    
    test('GetInternationalLawyersListUseCase - Success', () async {
      // Given
      final mockRepository = MockInternationalLawyersAdminRepository();
      final expectedResponse = InternationalLawyersListResponse(
        providers: [
          const InternationalLawyerProvider(
            id: 'provider-1',
            providerCategory: 'international',
            isApproved: 1,
          ),
        ],
        currentPage: 1,
        onboardingCount: 5,
        deniedCount: 2,
      );

      when(mockRepository.getInternationalLawyersList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        requestStatus: anyNamed('requestStatus'),
      )).thenAnswer((_) async => expectedResponse);

      final usecase = GetInternationalLawyersListUseCase(mockRepository);

      // When
      final result = await usecase.call(
        limit: 10,
        offset: 1,
        requestStatus: 'all',
      );

      // Then
      expect(result.providers.length, 1);
      expect(result.onboardingCount, 5);
      expect(result.deniedCount, 2);
      verify(mockRepository.getInternationalLawyersList(
        limit: 10,
        offset: 1,
        requestStatus: 'all',
      )).called(1);
    });

    // ============================================================
    // Test 2: Get International Lawyer Details
    // ============================================================

    test('GetInternationalLawyerDetailsUseCase - Success', () async {
      // Given
      final mockRepository = MockInternationalLawyersAdminRepository();
      final expectedResponse = InternationalLawyerDetailsResponse(
        providerInfo: const InternationalLawyerProvider(
          id: 'provider-1',
          providerCategory: 'international',
          isApproved: 1,
        ),
        bookingOverview: const [
          BookingOverview(bookingStatus: 'pending', total: 3),
          BookingOverview(bookingStatus: 'completed', total: 10),
        ],
      );

      when(mockRepository.getInternationalLawyerDetails(any))
          .thenAnswer((_) async => expectedResponse);

      final usecase = GetInternationalLawyerDetailsUseCase(mockRepository);

      // When
      final result = await usecase.call('provider-1');

      // Then
      expect(result.providerInfo.id, 'provider-1');
      expect(result.bookingOverview.length, 2);
      expect(result.bookingOverview[0].bookingStatus, 'pending');
      verify(mockRepository.getInternationalLawyerDetails('provider-1')).called(1);
    });

    // ============================================================
    // Test 3: Filter by Status - Pending
    // ============================================================

    test('GetInternationalLawyersListUseCase - Filter Pending', () async {
      final mockRepository = MockInternationalLawyersAdminRepository();
      final usecase = GetInternationalLawyersListUseCase(mockRepository);

      await usecase.call(
        limit: 10,
        offset: 1,
        requestStatus: 'pending',
      );

      verify(mockRepository.getInternationalLawyersList(
        limit: 10,
        offset: 1,
        requestStatus: 'pending',
      )).called(1);
    });

    // ============================================================
    // Test 4: Filter by Status - Denied
    // ============================================================

    test('GetInternationalLawyersListUseCase - Filter Denied', () async {
      final mockRepository = MockInternationalLawyersAdminRepository();
      final usecase = GetInternationalLawyersListUseCase(mockRepository);

      await usecase.call(
        limit: 10,
        offset: 1,
        requestStatus: 'denied',
      );

      verify(mockRepository.getInternationalLawyersList(
        limit: 10,
        offset: 1,
        requestStatus: 'denied',
      )).called(1);
    });

    // ============================================================
    // Test 5: Pagination
    // ============================================================

    test('GetInternationalLawyersListUseCase - Pagination', () async {
      final mockRepository = MockInternationalLawyersAdminRepository();
      final usecase = GetInternationalLawyersListUseCase(mockRepository);

      // Page 1
      await usecase.call(limit: 10, offset: 1, requestStatus: 'all');
      verify(mockRepository.getInternationalLawyersList(
        limit: 10,
        offset: 1,
        requestStatus: 'all',
      )).called(1);

      // Page 2
      await usecase.call(limit: 10, offset: 2, requestStatus: 'all');
      verify(mockRepository.getInternationalLawyersList(
        limit: 10,
        offset: 2,
        requestStatus: 'all',
      )).called(1);
    });

    // ============================================================
    // Test 6: Approval Status
    // ============================================================

    test('InternationalLawyerProvider - Approval Status', () {
      final pendingLawyer = const InternationalLawyerProvider(
        id: '1',
        providerCategory: 'international',
        isApproved: 0, // pending
      );

      final approvedLawyer = const InternationalLawyerProvider(
        id: '2',
        providerCategory: 'international',
        isApproved: 1, // approved
      );

      final deniedLawyer = const InternationalLawyerProvider(
        id: '3',
        providerCategory: 'international',
        isApproved: 2, // denied
      );

      expect(pendingLawyer.isApproved, 0);
      expect(approvedLawyer.isApproved, 1);
      expect(deniedLawyer.isApproved, 2);
    });

    // ============================================================
    // Test 7: Model Serialization
    // ============================================================

    test('InternationalLawyerProvider - toJson and fromJson', () {
      final lawyer = const InternationalLawyerProvider(
        id: 'provider-1',
        providerCategory: 'international',
        isApproved: 1,
      );

      final json = lawyer.toJson();
      final lawyerFromJson = InternationalLawyerProvider.fromJson(json);

      expect(lawyerFromJson.id, lawyer.id);
      expect(lawyerFromJson.providerCategory, lawyer.providerCategory);
      expect(lawyerFromJson.isApproved, lawyer.isApproved);
    });

    // ============================================================
    // Test 8: Error Handling
    // ============================================================

    test('GetInternationalLawyersListUseCase - Error', () async {
      final mockRepository = MockInternationalLawyersAdminRepository();
      final usecase = GetInternationalLawyersListUseCase(mockRepository);

      when(mockRepository.getInternationalLawyersList(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        requestStatus: anyNamed('requestStatus'),
      )).thenThrow(Exception('Network Error'));

      expect(
        () => usecase.call(limit: 10, offset: 1, requestStatus: 'all'),
        throwsException,
      );
    });
  });
}

// ============================================================
// Mock Classes
// ============================================================

class MockInternationalLawyersAdminRepository 
    extends Mock 
    implements InternationalLawyersAdminRepository {}

// ============================================================
// Running Tests
// ============================================================

// Command line:
// flutter test test/features/tt_club_landing/admin_lawyers_test.dart

// With coverage:
// flutter test --coverage test/features/tt_club_landing/admin_lawyers_test.dart

