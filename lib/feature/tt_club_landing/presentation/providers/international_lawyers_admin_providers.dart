import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:demandium/api/remote/client_api.dart';

import '../../data/datasources/international_lawyers_admin_remote_datasource.dart';
import '../../data/repositories/international_lawyers_admin_repository_impl.dart';
import '../../domain/entities/international_lawyer_details_response.dart';
import '../../domain/entities/international_lawyers_list_response.dart';
import '../../domain/repositories/international_lawyers_admin_repository.dart';
import '../../domain/usecases/get_international_lawyer_details_usecase.dart';
import '../../domain/usecases/get_international_lawyers_list_usecase.dart';

/// Provider for Admin Remote DataSource
final _internationalLawyersAdminRemoteDataSourceProvider =
    Provider<InternationalLawyersAdminRemoteDataSource>((ref) {
  final apiClient = Get.find<ApiClient>();
  return InternationalLawyersAdminRemoteDataSource(apiClient);
});

/// Provider for Admin Repository
final _internationalLawyersAdminRepositoryProvider =
    Provider<InternationalLawyersAdminRepository>((ref) {
  return InternationalLawyersAdminRepositoryImpl(
    ref.watch(_internationalLawyersAdminRemoteDataSourceProvider),
  );
});

/// Provider for Get International Lawyers List UseCase
final _getInternationalLawyersListUseCaseProvider =
    Provider<GetInternationalLawyersListUseCase>((ref) {
  return GetInternationalLawyersListUseCase(
    ref.watch(_internationalLawyersAdminRepositoryProvider),
  );
});

/// Provider for Get International Lawyer Details UseCase
final _getInternationalLawyerDetailsUseCaseProvider =
    Provider<GetInternationalLawyerDetailsUseCase>((ref) {
  return GetInternationalLawyerDetailsUseCase(
    ref.watch(_internationalLawyersAdminRepositoryProvider),
  );
});

/// FutureProvider for fetching international lawyers list
///
/// Usage:
/// ```dart
/// final lawyersAsync = ref.watch(internationalLawyersListProvider(
///   limit: 10,
///   offset: 1,
///   requestStatus: 'all',
/// ));
/// ```
final internationalLawyersListProvider = FutureProvider.family<
    InternationalLawyersListResponse,
    ({int limit, int offset, String requestStatus})>((ref, params) async {
  return ref
      .watch(_getInternationalLawyersListUseCaseProvider)
      .call(
        limit: params.limit,
        offset: params.offset,
        requestStatus: params.requestStatus,
      );
});

/// FutureProvider for fetching individual international lawyer details
///
/// Usage:
/// ```dart
/// final lawyerDetailsAsync = ref.watch(
///   internationalLawyerDetailsProvider('provider-uuid'),
/// );
/// ```
final internationalLawyerDetailsProvider =
    FutureProvider.family<InternationalLawyerDetailsResponse, String>(
        (ref, providerId) async {
  return ref
      .watch(_getInternationalLawyerDetailsUseCaseProvider)
      .call(providerId);
});

