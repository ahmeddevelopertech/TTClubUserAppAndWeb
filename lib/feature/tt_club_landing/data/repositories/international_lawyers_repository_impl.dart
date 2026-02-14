import '../../domain/entities/international_lawyer_visual.dart';
import '../../domain/repositories/international_lawyers_repository.dart';
import '../datasources/international_lawyers_local_datasource.dart';
import '../datasources/international_lawyers_remote_datasource.dart';

class InternationalLawyersRepositoryImpl implements InternationalLawyersRepository {
  final InternationalLawyersRemoteDataSource _remote;
  final InternationalLawyersLocalDataSource _local;

  const InternationalLawyersRepositoryImpl(this._remote, this._local);

  @override
  Future<List<InternationalLawyerVisual>> getInternationalLawyers() async {
    try {
      // Try to fetch from remote API first
      return await _remote.getInternationalLawyers();
    } catch (e) {
      // Fallback to local data if remote fails
      return await _local.load();
    }
  }
}
