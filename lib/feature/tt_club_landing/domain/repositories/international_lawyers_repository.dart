import '../entities/international_lawyer_visual.dart';

abstract class InternationalLawyersRepository {
  Future<List<InternationalLawyerVisual>> getInternationalLawyers();
}
