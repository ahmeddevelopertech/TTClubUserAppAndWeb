import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/tt_club_landing_local_datasource.dart';
import '../../data/repositories/tt_club_landing_repository_impl.dart';
import '../../domain/entities/landing_config.dart';
import '../../domain/repositories/tt_club_landing_repository.dart';
import '../../domain/usecases/get_landing_config_usecase.dart';

final _dsProvider = Provider<TtClubLandingLocalDataSource>((ref) {
  return const TtClubLandingLocalDataSource();
});

final _repoProvider = Provider<TtClubLandingRepository>((ref) {
  return TtClubLandingRepositoryImpl(ref.watch(_dsProvider));
});

final _useCaseProvider = Provider<GetLandingConfigUseCase>((ref) {
  return GetLandingConfigUseCase(ref.watch(_repoProvider));
});

final landingConfigProvider = FutureProvider<LandingConfig>((ref) async {
  return ref.watch(_useCaseProvider).call();
});
