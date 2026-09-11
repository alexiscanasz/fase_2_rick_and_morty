import 'character_entity.dart';

class CharactersPage {
  const CharactersPage({required this.characters, required this.hasNext});

  final List<Character> characters;
  final bool hasNext;
}
