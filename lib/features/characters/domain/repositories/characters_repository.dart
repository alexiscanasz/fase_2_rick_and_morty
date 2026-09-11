import '../../../../core/error/result.dart';
import '../entities/character_entity.dart';
import '../entities/characters_page.dart';

abstract class CharactersRepository {
  Future<Result<CharactersPage>> getCharacters({String? name, int page = 1});
  Future<Result<Character>> getCharacterDetail(int id);
}
