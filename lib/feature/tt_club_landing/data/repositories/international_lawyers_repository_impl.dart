import '../../domain/entities/international_lawyer_visual.dart';
import '../../domain/repositories/international_lawyers_repository.dart';
import '../datasources/international_lawyers_remote_datasource.dart';

class InternationalLawyersRepositoryImpl implements InternationalLawyersRepository {
  final InternationalLawyersRemoteDataSource _remote;

  const InternationalLawyersRepositoryImpl(this._remote);

  @override
  Future<List<InternationalLawyerVisual>> getInternationalLawyers() async {
    // Always prefer the remote API. Do not silently fall back to the local JSON.
    // If the remote call fails the error will propagate so the caller (UI/provider)
    // can show an error state and avoid stale/local-only data.
    return await _remote.getInternationalLawyers();
  }
}
