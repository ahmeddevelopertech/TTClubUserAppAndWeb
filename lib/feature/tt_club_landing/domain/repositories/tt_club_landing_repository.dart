import '../entities/landing_config.dart';

abstract class TtClubLandingRepository {
  Future<LandingConfig> getLandingConfig();
}
