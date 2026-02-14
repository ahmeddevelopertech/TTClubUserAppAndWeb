import 'dart:convert';
import 'package:demandium/api/remote/client_api.dart';
import '../../domain/entities/international_lawyers_list_response.dart';
import '../../domain/entities/international_lawyer_details_response.dart';

class InternationalLawyersAdminRemoteDataSource {
  final ApiClient _apiClient;

  const InternationalLawyersAdminRemoteDataSource(this._apiClient);

  /// Fetch list of international lawyer providers (admin)
  /// GET /api/v1/admin/provider/data/international-requests
  ///
  /// Parameters:
  /// - limit: number of items per page
  /// - offset: pagination offset
  /// - requestStatus: 'pending', 'denied', or 'all'
  Future<InternationalLawyersListResponse> getInternationalLawyersList({
    required int limit,
    required int offset,
    required String requestStatus,
  }) async {
    try {
      final uri = '/api/v1/admin/provider/data/international-requests?'
          'limit=$limit&offset=$offset&request_status=$requestStatus';

      final response = await _apiClient.getData(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = _parseResponse(response.body);
        return InternationalLawyersListResponse.fromJson(decoded);
      } else {
        throw Exception(
            'Failed to load international lawyers list: ${response.statusText}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch details of a single international lawyer provider (admin)
  /// GET /api/v1/admin/provider/data/overview/{user_id}
  ///
  /// Note: Path parameter is user_id but actually passes provider_id
  Future<InternationalLawyerDetailsResponse> getInternationalLawyerDetails(
    String providerId,
  ) async {
    try {
      final uri = '/api/v1/admin/provider/data/overview/$providerId';

      final response = await _apiClient.getData(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = _parseResponse(response.body);
        return InternationalLawyerDetailsResponse.fromJson(decoded);
      } else {
        throw Exception(
            'Failed to load international lawyer details: ${response.statusText}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to parse response body (handles String or Map)
  Map<String, dynamic> _parseResponse(dynamic body) {
    if (body is String) {
      if (body.isEmpty) {
        throw const FormatException('Empty response body');
      }
      return jsonDecode(body) as Map<String, dynamic>;
    } else if (body is Map<String, dynamic>) {
      return body;
    } else {
      throw const FormatException('Invalid response format');
    }
  }
}


