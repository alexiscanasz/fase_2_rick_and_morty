import 'package:portal_remoto_rick_and_morty_fase_2_ca_bloc/features/characters/domain/repositories/characters_repository.dart';

import '../../../../core/error/result.dart';
import '../entities/characters_page.dart';

class GetCharactersUseCase {
  final CharactersRepository repository;

  GetCharactersUseCase({required this.repository});

  Future<Result<CharactersPage>> call({String? name, int page = 1}) =>
      repository.getCharacters(name: name, page: page);
}
