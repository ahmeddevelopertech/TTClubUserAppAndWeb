import '../entities/international_lawyer_visual.dart';
import '../repositories/international_lawyers_repository.dart';

class GetInternationalLawyersUseCase {
  final InternationalLawyersRepository _repo;
  const GetInternationalLawyersUseCase(this._repo);

  Future<List<InternationalLawyerVisual>> call() => _repo.getInternationalLawyers();
}
