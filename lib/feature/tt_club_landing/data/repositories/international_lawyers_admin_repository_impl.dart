import '../../domain/entities/international_lawyer_details_response.dart';
import '../../domain/entities/international_lawyers_list_response.dart';
import '../../domain/repositories/international_lawyers_admin_repository.dart';
import '../datasources/international_lawyers_admin_remote_datasource.dart';

class InternationalLawyersAdminRepositoryImpl
    implements InternationalLawyersAdminRepository {
  final InternationalLawyersAdminRemoteDataSource _remote;

  const InternationalLawyersAdminRepositoryImpl(this._remote);

  @override
  Future<InternationalLawyersListResponse> getInternationalLawyersList({
    required int limit,
    required int offset,
    required String requestStatus,
  }) =>
      _remote.getInternationalLawyersList(
        limit: limit,
        offset: offset,
        requestStatus: requestStatus,
      );

  @override
  Future<InternationalLawyerDetailsResponse> getInternationalLawyerDetails(
    String providerId,
  ) =>
      _remote.getInternationalLawyerDetails(providerId);
}

