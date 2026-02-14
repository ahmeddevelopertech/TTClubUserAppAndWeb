import '../../domain/entities/international_lawyer_details_response.dart';
import '../../domain/entities/international_lawyers_list_response.dart';

abstract class InternationalLawyersAdminRepository {
  Future<InternationalLawyersListResponse> getInternationalLawyersList({
    required int limit,
    required int offset,
    required String requestStatus,
  });

  Future<InternationalLawyerDetailsResponse> getInternationalLawyerDetails(
    String providerId,
  );
}

