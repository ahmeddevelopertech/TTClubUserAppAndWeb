import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/international_lawyers_local_datasource.dart';
import '../../data/repositories/international_lawyers_repository_impl.dart';
import '../../domain/entities/international_lawyer_visual.dart';
import '../../domain/repositories/international_lawyers_repository.dart';
import '../../domain/usecases/get_international_lawyers_usecase.dart';

final assetBundleProvider = Provider<AssetBundle>((ref) => rootBundle);

final _internationalLawyersDataSourceProvider =
    Provider<InternationalLawyersLocalDataSource>((ref) {
  return InternationalLawyersLocalDataSource(ref.watch(assetBundleProvider));
});

final _internationalLawyersRepositoryProvider =
    Provider<InternationalLawyersRepository>((ref) {
  return InternationalLawyersRepositoryImpl(ref.watch(_internationalLawyersDataSourceProvider));
});

final _internationalLawyersUseCaseProvider =
    Provider<GetInternationalLawyersUseCase>((ref) {
  return GetInternationalLawyersUseCase(ref.watch(_internationalLawyersRepositoryProvider));
});

final internationalLawyersProvider = FutureProvider<List<InternationalLawyerVisual>>((ref) async {
  return ref.watch(_internationalLawyersUseCaseProvider).call();
});
