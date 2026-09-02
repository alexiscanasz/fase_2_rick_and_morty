import 'package:portal_remoto_rick_and_morty_fase_2_ca_bloc/features/characters/domain/entities/character_entity.dart';
import 'package:portal_remoto_rick_and_morty_fase_2_ca_bloc/features/characters/domain/repositories/characters_repository.dart';

import '../../../../core/error/result.dart';

class AddCharacterToFavoriteUseCase {
  final CharactersRepository repository;

  AddCharacterToFavoriteUseCase({required this.repository});

  Future<Result<bool>> call(Character character) =>
      repository.addCharacterToFavorite(character);
}
