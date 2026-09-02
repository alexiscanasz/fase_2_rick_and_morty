import '../../../../core/error/result.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterRemoteDatasource characterRemoteDatasource;
  final CharacterLocalDatasource characterLocalDatasource;

  CharactersRepositoryImpl({
    required this.characterRemoteDatasource,
    required this.characterLocalDatasource,
  });

  @override
  Future<Result<List<Character>>> getCharacters() async {
    try {
      final characters = await characterRemoteDatasource.getCharacters();
      return Success(characters);
    } catch (_) {
      return const Failure('No se pudieron cargar los personajes');
    }
  }

  @override
  Future<Result<Character>> getCharacterDetail(int id) async {
    try {
      final character = await characterRemoteDatasource.getCharacterDetail(id);
      return Success(character);
    } catch (_) {
      return const Failure('No se pudo cargar el personaje');
    }
  }

  @override
  Future<Result<bool>> addCharacterToFavorite(Character character) async {
    try {
      final added = await characterLocalDatasource.addCharacterToFavorite(
        CharacterModel.fromEntity(character),
      );
      return Success(added);
    } catch (_) {
      return const Failure('No se pudo agregar el personaje a favoritos');
    }
  }

  @override
  Future<Result<List<Character>>> getFavoriteCharacters() async {
    try {
      final characters = await characterLocalDatasource.getFavoriteCharacters();
      return Success(characters);
    } catch (_) {
      return const Failure('No se pudieron cargar los favoritos');
    }
  }
}
