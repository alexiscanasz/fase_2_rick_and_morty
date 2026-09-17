import '../../../../core/core.dart';
import '../entities/character_entity.dart';
import '../repositories/characters_repository.dart';

/// Caso de uso que obtiene el detalle de un personaje por su id
class RmGetCharacterDetailUseCase {
  final RmCharactersRepository repository;

  RmGetCharacterDetailUseCase({required this.repository});

  Future<RmResult<RmCharacterEntity>> call(int id) => repository.getById(id);
}
