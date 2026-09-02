import '../../../../core/error/result.dart';
import '../entities/character_entity.dart';

abstract class CharactersRepository {
  Future<Result<List<Character>>> getCharacters();
  Future<Result<Character>> getCharacterDetail(int id);
  Future<Result<bool>> addCharacterToFavorite(Character character);
  Future<Result<List<Character>>> getFavoriteCharacters();
}
