import '../../domain/entities/international_lawyer_details_response.dart';
import '../../domain/repositories/international_lawyers_admin_repository.dart';

class GetInternationalLawyerDetailsUseCase {
  final InternationalLawyersAdminRepository _repository;

  const GetInternationalLawyerDetailsUseCase(this._repository);

  Future<InternationalLawyerDetailsResponse> call(String providerId) =>
      _repository.getInternationalLawyerDetails(providerId);
}

