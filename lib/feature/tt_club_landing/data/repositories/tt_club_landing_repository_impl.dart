import '../../domain/entities/landing_config.dart';
import '../../domain/repositories/tt_club_landing_repository.dart';
import '../datasources/tt_club_landing_local_datasource.dart';

class TtClubLandingRepositoryImpl implements TtClubLandingRepository {
  final TtClubLandingLocalDataSource _local;

  const TtClubLandingRepositoryImpl(this._local);

  @override
  Future<LandingConfig> getLandingConfig() => _local.fetch();
}
