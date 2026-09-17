import '../../../../core/core.dart';
import '../entities/characters_page.dart';
import '../repositories/characters_repository.dart';

/// Obtiene un listado de personajes, filtrando opcionalmente por [name] e inicialmente
/// consultando la primera pagina a menos que se indique la pagina a solicitar
class RmGetCharactersUseCase {
  final RmCharactersRepository repository;

  RmGetCharactersUseCase({required this.repository});

  Future<RmResult<RmCharactersPage>> call({String? name, int page = 1}) =>
      repository.getAll(name: name, page: page);
}
