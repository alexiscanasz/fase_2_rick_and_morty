import '../../../../core/core.dart';
import '../entities/character_entity.dart';
import '../entities/characters_page.dart';

/// Punto de acceso del dominio a los datos de personajes, sin exponer
/// detalles de la fuente (API remota, cache, etc.) a las capas superiores
abstract interface class RmCharactersRepository {
  /// Obtiene un listado de personajes, filtrando opcionalmente por [name] e inicialmente
  /// consultando la primera pagina a menos que se indique la pagina a solicitar
  Future<RmResult<RmCharactersPage>> getAll({String? name, int page = 1});

  /// Obtiene el detalle del personaje con el [id] indicado
  Future<RmResult<RmCharacterEntity>> getById(int id);
}
