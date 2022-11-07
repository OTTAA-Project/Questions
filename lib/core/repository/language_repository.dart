abstract class LanguageRepository {
  const LanguageRepository();

  Future<void> init();
  Future<void> save(String message);
  Future<void> getAll();
}
