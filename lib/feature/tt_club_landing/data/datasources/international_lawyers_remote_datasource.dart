import 'dart:convert';
import 'package:demandium/api/remote/client_api.dart';
import '../../domain/entities/international_lawyer_visual.dart';

class InternationalLawyersRemoteDataSource {
  final ApiClient _apiClient;

  const InternationalLawyersRemoteDataSource(this._apiClient);

  Future<List<InternationalLawyerVisual>> getInternationalLawyers() async {
    try {
      final response = await _apiClient.getData('/api/v1/international-lawyers');

      if (response.statusCode == 200) {
        final List<dynamic> decoded = response.body is String
            ? (response.body as String).isEmpty
                ? []
                : (response.body as String).startsWith('[')
                    ? jsonDecode(response.body)
                    : jsonDecode(response.body)['data'] ?? []
            : response.body is List
                ? response.body
                : (response.body is Map && response.body['data'] != null)
                    ? response.body['data']
                    : [];

        if (decoded is! List) {
          throw const FormatException(
              'International lawyers API must return a JSON array or object with data array');
        }

        return decoded
            .cast<Map<String, dynamic>>()
            .map(InternationalLawyerVisual.fromJson)
            .toList(growable: false);
      } else {
        throw Exception(
            'Failed to load international lawyers: ${response.statusText}');
      }
    } catch (e) {
      rethrow;
    }
  }
}


