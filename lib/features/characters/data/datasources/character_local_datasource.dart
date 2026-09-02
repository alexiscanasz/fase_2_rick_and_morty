import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../domain/entities/character_entity.dart';
import '../models/character_model.dart';

abstract class CharacterLocalDatasource {
  Future<bool> addCharacterToFavorite(CharacterModel character);
  Future<List<Character>> getFavoriteCharacters();
}

class HiveCharacterLocalDatasourceImpl implements CharacterLocalDatasource {
  static const _favoriteCharactersBoxName = 'favorite_characters';

  final Future<void> _initialization;

  HiveCharacterLocalDatasourceImpl() : _initialization = Hive.initFlutter();

  @override
  Future<bool> addCharacterToFavorite(CharacterModel character) async {
    await _initialization;
    final box = await Hive.openBox(_favoriteCharactersBoxName);
    try {
      await box.put(character.id, character.toJson());
      return true;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    } finally {
      await box.close();
    }
  }

  @override
  Future<List<Character>> getFavoriteCharacters() async {
    await _initialization;
    final box = await Hive.openBox(_favoriteCharactersBoxName);
    try {
      return box.values
          .map((character) => CharacterModel.fromJson(character))
          .toList();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    } finally {
      await box.close();
    }
  }
}
