import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../data/datasources/international_lawyers_remote_datasource.dart';
import '../../data/repositories/international_lawyers_repository_impl.dart';
import '../../domain/entities/international_lawyer_visual.dart';
import '../../domain/repositories/international_lawyers_repository.dart';
import '../../domain/usecases/get_international_lawyers_usecase.dart';
import 'package:demandium/api/remote/client_api.dart';

final _internationalLawyersRemoteDataSourceProvider =
    Provider<InternationalLawyersRemoteDataSource>((ref) {
  final apiClient = Get.find<ApiClient>();
  return InternationalLawyersRemoteDataSource(apiClient);
});

final _internationalLawyersRepositoryProvider =
    Provider<InternationalLawyersRepository>((ref) {
  // Repository uses remote API only
  return InternationalLawyersRepositoryImpl(
    ref.watch(_internationalLawyersRemoteDataSourceProvider),
  );
});

final _internationalLawyersUseCaseProvider =
    Provider<GetInternationalLawyersUseCase>((ref) {
  return GetInternationalLawyersUseCase(ref.watch(_internationalLawyersRepositoryProvider));
});

final internationalLawyersProvider = FutureProvider<List<InternationalLawyerVisual>>((ref) async {
  return ref.watch(_internationalLawyersUseCaseProvider).call();
});
