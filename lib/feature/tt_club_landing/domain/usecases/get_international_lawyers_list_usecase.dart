import '../../domain/entities/international_lawyers_list_response.dart';
import '../../domain/repositories/international_lawyers_admin_repository.dart';

class GetInternationalLawyersListUseCase {
  final InternationalLawyersAdminRepository _repository;

  const GetInternationalLawyersListUseCase(this._repository);

  Future<InternationalLawyersListResponse> call({
    required int limit,
    required int offset,
    required String requestStatus,
  }) =>
      _repository.getInternationalLawyersList(
        limit: limit,
        offset: offset,
        requestStatus: requestStatus,
      );
}

