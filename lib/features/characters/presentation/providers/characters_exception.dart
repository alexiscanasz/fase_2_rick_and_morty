/// Excepcion lanzada dentro de la capa de presentacion cuando un [RmResult]
/// de este feature resuelve en [RmFailure], para propagar el mensaje de error
/// a traves de los `AsyncNotifier`/`FutureProvider` que consumen la UI
class RmCharactersException implements Exception {
  const RmCharactersException(this.message);

  final String message;

  @override
  String toString() => message;
}
