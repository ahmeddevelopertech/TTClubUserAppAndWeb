import '../entities/landing_config.dart';
import '../repositories/tt_club_landing_repository.dart';

class GetLandingConfigUseCase {
  final TtClubLandingRepository _repo;
  const GetLandingConfigUseCase(this._repo);

  Future<LandingConfig> call() => _repo.getLandingConfig();
}
