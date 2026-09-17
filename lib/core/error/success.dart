part of 'result.dart';

/// Caso exitoso de [RmResult], con el [value] obtenido
final class RmSuccess<T> extends RmResult<T> {
  const RmSuccess(this.value);

  final T value;
}
