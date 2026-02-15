import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium/api/remote/client_api.dart';

class LawyerNetworkImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget fallback;
  final int? cacheWidth;
  final FilterQuality filterQuality;

  const LawyerNetworkImage({
    super.key,
    required this.path,
    required this.fallback,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.filterQuality = FilterQuality.low,
  });

  bool _isRemote(String value) {
    final p = value.trim().toLowerCase();
    return p.startsWith('http://') || p.startsWith('https://');
  }

  bool _isSvg(String value) {
    final p = value.trim().toLowerCase();
    return p.endsWith('.svg') || p.contains('.svg?');
  }

  Map<String, String>? _headers() {
    if (!Get.isRegistered<ApiClient>()) return null;
    final api = Get.find<ApiClient>();
    final token = api.token ?? '';
    if (token.trim().isEmpty) return null;
    return <String, String>{'Authorization': 'Bearer $token'};
  }

  @override
  Widget build(BuildContext context) {
    final src = path.trim();
    if (src.isEmpty) return fallback;

    if (_isRemote(src)) {
      if (_isSvg(src)) return fallback;

      return Image.network(
        src,
        fit: fit,
        cacheWidth: cacheWidth,
        filterQuality: filterQuality,
        headers: _headers(),
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    if (_isSvg(src)) return fallback;

    return Image.asset(
      src,
      fit: fit,
      cacheWidth: cacheWidth,
      filterQuality: filterQuality,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
