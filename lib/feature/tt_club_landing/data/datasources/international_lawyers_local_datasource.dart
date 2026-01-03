import 'dart:convert';
import 'package:flutter/services.dart';

import '../../domain/entities/international_lawyer_visual.dart';

class InternationalLawyersLocalDataSource {
  final AssetBundle _bundle;

  const InternationalLawyersLocalDataSource(this._bundle);

  Future<List<InternationalLawyerVisual>> load() async {
    final raw = await _bundle.loadString('assets/data/international_lawyers.json');
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const FormatException('international_lawyers.json must be a JSON array');
    }

    return decoded
        .cast<Map<String, dynamic>>()
        .map(InternationalLawyerVisual.fromJson)
        .toList(growable: false);
  }
}
