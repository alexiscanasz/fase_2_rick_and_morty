import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/character_remote_datasource.dart';

/// Implementación de [RmCharactersRepository] que obtiene los datos de la api
/// de rick and morty y traduce los errores de red a [RmFailure]
class RmCharactersRepositoryImpl implements RmCharactersRepository {
  RmCharactersRepositoryImpl({required this.characterRemoteDatasource});

  final RmCharacterRemoteDatasource characterRemoteDatasource;

  String _messageFor(DioException error, String defaultMessage) {
    if (error.response?.statusCode == 429) {
      return 'Demasiadas solicitudes a la API. Espera un momento e intenta de nuevo';
    }
    return defaultMessage;
  }

  @override
  Future<RmResult<RmCharactersPage>> getAll({
    String? name,
    int page = 1,
  }) async {
    try {
      final result = await characterRemoteDatasource.getCharacters(
        name: name,
        page: page,
      );
      return RmSuccess(result);
    } on DioException catch (e) {
      return RmFailure(_messageFor(e, 'No se pudieron cargar los personajes'));
    } catch (_) {
      return const RmFailure('No se pudieron cargar los personajes');
    }
  }

  @override
  Future<RmResult<RmCharacterEntity>> getById(int id) async {
    try {
      final character = await characterRemoteDatasource.getCharacterDetail(id);
      return RmSuccess(character);
    } on DioException catch (e) {
      return RmFailure(_messageFor(e, 'No se pudo cargar el personaje'));
    } catch (_) {
      return const RmFailure('No se pudo cargar el personaje');
    }
  }
}
