import '../../domain/entities/international_lawyer_visual.dart';
import '../../domain/repositories/international_lawyers_repository.dart';
import '../datasources/international_lawyers_local_datasource.dart';

class InternationalLawyersRepositoryImpl implements InternationalLawyersRepository {
  final InternationalLawyersLocalDataSource _local;

  const InternationalLawyersRepositoryImpl(this._local);

  @override
  Future<List<InternationalLawyerVisual>> getInternationalLawyers() => _local.load();
}
