import 'package:dio/dio.dart';

import '../models/character_model.dart';

abstract class CharacterRemoteDatasource {
  Future<List<CharacterModel>> getCharacters();
  Future<CharacterModel> getCharacterDetail(int id);
}

class CharacterRemoteDatasourceImpl implements CharacterRemoteDatasource {
  final Dio dio;
  CharacterRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CharacterModel>> getCharacters() async {
    final resp = await dio.get('https://rickandmortyapi.com/api/character');

    return CharacterModel.listFromJson(resp.data);
  }

  @override
  Future<CharacterModel> getCharacterDetail(int id) async {
    final resp = await dio.get('https://rickandmortyapi.com/api/character/$id');

    return CharacterModel.fromJson(resp.data);
  }
}
