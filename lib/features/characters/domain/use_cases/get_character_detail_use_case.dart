import 'package:portal_remoto_rick_and_morty_fase_2_ca_bloc/features/characters/domain/repositories/characters_repository.dart';

import '../../../../core/error/result.dart';
import '../entities/character_entity.dart';

class GetCharacterDetailUseCase {
  final CharactersRepository repository;

  GetCharacterDetailUseCase({required this.repository});

  Future<Result<Character>> call(int id) => repository.getCharacterDetail(id);
}
