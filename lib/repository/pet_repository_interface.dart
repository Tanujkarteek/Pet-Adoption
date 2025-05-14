import '../constants/data.dart';

/// Interface for pet data operations
abstract class PetRepositoryInterface {
  /// Fetches pets data with caching strategy
  Future<List<DataModel>> fetchPets();

  /// Forces a refresh of pets data (clears cache)
  Future<List<DataModel>> refreshPets();
}
