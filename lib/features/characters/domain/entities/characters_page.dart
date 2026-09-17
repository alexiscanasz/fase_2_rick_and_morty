import 'character_entity.dart';

class RmCharactersPage {
  const RmCharactersPage({required this.characters, required this.hasNext});

  final List<RmCharacterEntity> characters;
  final bool hasNext;
}
