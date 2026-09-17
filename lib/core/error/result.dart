part 'success.dart';
part 'failure.dart';

/// Resultado de una operacion, puede ser [RmSuccess] o [RmFailure]
/// Se usa en vez de excepciones para obligar a manejar ambos casos
sealed class RmResult<T> {
  const RmResult();
}
