import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/entities/characters_page.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/character_remote_datasource.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterRemoteDatasource characterRemoteDatasource;

  CharactersRepositoryImpl({required this.characterRemoteDatasource});

  @override
  Future<Result<CharactersPage>> getCharacters({String? name, int page = 1}) async {
    try {
      final result = await characterRemoteDatasource.getCharacters(name: name, page: page);
      return Success(result);
    } on DioException catch (e) {
      return Failure(_messageFor(e, 'No se pudieron cargar los personajes'));
    } catch (_) {
      return const Failure('No se pudieron cargar los personajes');
    }
  }

  @override
  Future<Result<Character>> getCharacterDetail(int id) async {
    try {
      final character = await characterRemoteDatasource.getCharacterDetail(id);
      return Success(character);
    } on DioException catch (e) {
      return Failure(_messageFor(e, 'No se pudo cargar el personaje'));
    } catch (_) {
      return const Failure('No se pudo cargar el personaje');
    }
  }

  String _messageFor(DioException error, String defaultMessage) {
    if (error.response?.statusCode == 429) {
      return 'Demasiadas solicitudes a la API. Espera un momento e intenta de nuevo.';
    }
    return defaultMessage;
  }
}
