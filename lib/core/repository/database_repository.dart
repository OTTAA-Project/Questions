abstract class DatabaseRepository<T> {
  Future<void> init();
  Future<void> save(T data);
}
