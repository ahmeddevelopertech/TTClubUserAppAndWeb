import 'package:demandium/api/remote/client_api.dart';
import '../../domain/entities/international_lawyer_visual.dart';

class InternationalLawyersRemoteDataSource {
  final ApiClient _apiClient;

  const InternationalLawyersRemoteDataSource(this._apiClient);

  Future<List<InternationalLawyerVisual>> getInternationalLawyers() async {
    List<dynamic> providerItems = const <dynamic>[];

    try {
      providerItems = await _fetchFromAdminRequests();
    } catch (_) {
      providerItems = const <dynamic>[];
    }

    if (providerItems.isEmpty) {
      providerItems = await _fetchFromCustomerProviderList();
    }

    final visuals = <InternationalLawyerVisual>[];
    for (int i = 0; i < providerItems.length; i++) {
      final item = providerItems[i];
      if (item is! Map) continue;
      final provider = Map<String, dynamic>.from(item);

      if (!_isInternationalProvider(provider)) continue;

      final providerId = _asString(provider['id']);
      final providerInfo = providerId.isNotEmpty
          ? await _getProviderInfo(providerId)
          : null;

      final merged = <String, dynamic>{...provider};
      if (providerInfo != null) {
        merged.addAll(providerInfo);
        merged['owner'] = providerInfo['owner'] ?? merged['owner'];
        merged['zone'] = providerInfo['zone'] ?? merged['zone'];
      }

      visuals.add(_toVisual(merged, i));
    }

    return visuals;
  }

  Future<List<dynamic>> _fetchFromAdminRequests() async {
    const uri =
        '/api/v1/admin/provider/data/international-requests?limit=50&offset=1&request_status=all';
    final response = await _apiClient.getData(uri);
    if (response.statusCode != 200 || response.body is! Map) {
      return const <dynamic>[];
    }

    final body = Map<String, dynamic>.from(
      response.body as Map<dynamic, dynamic>,
    );
    final content = body['content'] is Map
        ? Map<String, dynamic>.from(body['content'] as Map<dynamic, dynamic>)
        : const <String, dynamic>{};
    final providersNode = content['providers'] is Map
        ? Map<String, dynamic>.from(
            content['providers'] as Map<dynamic, dynamic>,
          )
        : const <String, dynamic>{};
    return providersNode['data'] is List
        ? providersNode['data'] as List<dynamic>
        : const <dynamic>[];
  }

  Future<List<dynamic>> _fetchFromCustomerProviderList() async {
    final response = await _apiClient.postData(
      '/api/v1/customer/provider/list?limit=100&offset=1',
      {'sort_by': 'default', 'rating': '0'},
    );
    if (response.statusCode != 200 || response.body is! Map) {
      return const <dynamic>[];
    }

    final body = Map<String, dynamic>.from(
      response.body as Map<dynamic, dynamic>,
    );
    final content = body['content'] is Map
        ? Map<String, dynamic>.from(body['content'] as Map<dynamic, dynamic>)
        : const <String, dynamic>{};
    return content['data'] is List
        ? content['data'] as List<dynamic>
        : const <dynamic>[];
  }

  Future<Map<String, dynamic>?> _getProviderInfo(String providerId) async {
    final customerDetails = await _getProviderInfoFromCustomer(providerId);
    if (customerDetails != null) return customerDetails;

    return _getProviderInfoFromAdminOverview(providerId);
  }

  Future<Map<String, dynamic>?> _getProviderInfoFromCustomer(
    String providerId,
  ) async {
    final response = await _apiClient.getData(
      '/api/v1/customer/provider-details?id=$providerId&limit=10&offset=1',
    );
    if (response.statusCode != 200 || response.body is! Map) {
      return null;
    }

    final body = Map<String, dynamic>.from(
      response.body as Map<dynamic, dynamic>,
    );
    final content = body['content'] is Map
        ? Map<String, dynamic>.from(body['content'] as Map<dynamic, dynamic>)
        : null;
    final provider = content?['provider'] is Map
        ? Map<String, dynamic>.from(
            content!['provider'] as Map<dynamic, dynamic>,
          )
        : null;
    return provider;
  }

  Future<Map<String, dynamic>?> _getProviderInfoFromAdminOverview(
    String providerId,
  ) async {
    final response = await _apiClient.getData(
      '/api/v1/admin/provider/data/overview/$providerId',
    );
    if (response.statusCode != 200 || response.body is! Map) {
      return null;
    }

    final body = Map<String, dynamic>.from(
      response.body as Map<dynamic, dynamic>,
    );
    final content = body['content'] is Map
        ? Map<String, dynamic>.from(body['content'] as Map<dynamic, dynamic>)
        : null;
    final providerInfo = content?['provider_info'] is Map
        ? Map<String, dynamic>.from(
            content!['provider_info'] as Map<dynamic, dynamic>,
          )
        : null;
    return providerInfo;
  }

  InternationalLawyerVisual _toVisual(Map<String, dynamic> p, int i) {
    final owner = p['owner'] is Map
        ? Map<String, dynamic>.from(p['owner'] as Map<dynamic, dynamic>)
        : null;
    final account = owner != null && owner['account'] is Map
        ? Map<String, dynamic>.from(owner['account'] as Map<dynamic, dynamic>)
        : null;
    final zone = p['zone'] is Map
        ? Map<String, dynamic>.from(p['zone'] as Map<dynamic, dynamic>)
        : null;

    final companyName = _asString(p['company_name']);
    final firstName = _asString(account?['first_name']);
    final lastName = _asString(account?['last_name']);
    final fallbackName = [
      firstName,
      lastName,
    ].where((e) => e.isNotEmpty).join(' ').trim();

    final countryName = _firstNonEmpty([
      _asString(p['country_name']),
      _asString(p['country']),
      _asString(account?['country_name']),
      _asString(account?['country']),
    ]);

    final countryCode = _firstNonEmpty([
      _asString(p['country_code']),
      _asString(account?['country_code']),
      _asString(zone?['country_code']),
    ]);

    final photo = _firstNonEmpty([
      _asMaybePath(p['logo_full_path']),
      _asMaybePath(p['cover_image_full_path']),
      _asMaybePath(p['logo']),
      _asMaybePath(p['logo_original_full_path']),
      _asMaybePath(p['image_full_path']),
      _asMaybePath(p['profile_image_full_path']),
      _asMaybePath(p['profile_image']),
      _asMaybePath(account?['profile_image']),
      _asMaybePath(account?['profile_image_full_path']),
    ]);

    final addresses = p['addresses'] is List
        ? (p['addresses'] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : const <Map<String, dynamic>>[];
    final firstAddress = addresses.isNotEmpty ? addresses.first : null;

    return InternationalLawyerVisual(
      id: _asString(p['id']).isNotEmpty ? _asString(p['id']) : 'intl_${i + 1}',
      name: companyName.isNotEmpty
          ? companyName
          : (fallbackName.isNotEmpty ? fallbackName : 'محامي دولي'),
      countryName: countryName,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      photoAsset: _resolveImagePath(photo),
      flagAsset: null,
      specialty: _asString(p['provider_category']),
      address: _firstNonEmpty([
        _asString(p['company_address']),
        _asString(p['address']),
        _asString(p['street_address']),
        _asString(account?['address']),
        _asString(account?['street_address']),
        _asString(p['contact_person_address']),
        _asString(firstAddress?['address']),
        _asString(firstAddress?['street_address']),
        _asString(firstAddress?['address_line_1']),
        _asString(firstAddress?['address_line_2']),
      ]),
      email: _firstNonEmpty([
        _asString(p['email']),
        _asString(account?['email']),
      ]),
      phone: _firstNonEmpty([
        _asString(p['company_phone']),
        _asString(p['phone']),
        _asString(account?['phone']),
        _asString(p['contact_person_phone']),
      ]),
    );
  }

  bool _isInternationalProvider(Map<String, dynamic> provider) {
    final providerCategory = _asString(
      provider['provider_category'],
    ).toLowerCase();
    final providerType = _asString(provider['provider_type']).toLowerCase();
    final providerSubtype = _asString(provider['type']).toLowerCase();
    final isInternationalFlag = _asString(provider['is_international']);

    if (providerCategory.contains('international')) return true;
    if (providerType.contains('international')) return true;
    if (providerSubtype.contains('international')) return true;
    if (isInternationalFlag == '1' || isInternationalFlag == 'true') {
      return true;
    }
    return false;
  }

  String _asString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    return value.toString().trim();
  }

  String _asMaybePath(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    if (value is List && value.isNotEmpty) {
      return _asMaybePath(value.first);
    }
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final candidates = <String>[
        'path',
        'full_path',
        'relative_path',
        'storage',
        'url',
        'image',
        'logo',
        'value',
      ];
      for (final key in candidates) {
        final path = _asMaybePath(map[key]);
        if (path.isNotEmpty) return path;
      }
      return '';
    }
    return '';
  }

  String _firstNonEmpty(List<String> values) {
    for (final value in values) {
      if (value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }

  String _resolveImagePath(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return 'assets/images/user_placeholder.png';
    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return value;
    }
    if (value.startsWith('assets/')) {
      return value;
    }
    final base = (_apiClient.appBaseUrl ?? '').replaceAll(RegExp(r'/$'), '');
    if (base.isEmpty) return value;
    if (value.startsWith('/')) {
      return '$base$value';
    }
    return '$base/$value';
  }
}
