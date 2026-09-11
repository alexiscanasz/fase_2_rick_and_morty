import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/characters_page.dart';
import '../models/character_model.dart';

abstract class CharacterRemoteDatasource {
  Future<CharactersPage> getCharacters({String? name, int page = 1});
  Future<CharacterModel> getCharacterDetail(int id);
}

class CharacterRemoteDatasourceImpl implements CharacterRemoteDatasource {
  final Dio dio;
  CharacterRemoteDatasourceImpl({required this.dio});

  static const _rateLimitRetryDelay = Duration(milliseconds: 1500);

  @override
  Future<CharactersPage> getCharacters({String? name, int page = 1}) async {
    try {
      final resp = await _get(
        ApiConstants.charactersEndpoint,
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
          'page': page,
        },
      );

      final characters = CharacterModel.listFromJson(resp.data);
      final hasNext = (resp.data as Map?)?['info']?['next'] != null;
      return CharactersPage(characters: characters, hasNext: hasNext);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const CharactersPage(characters: [], hasNext: false);
      }
      rethrow;
    }
  }

  @override
  Future<CharacterModel> getCharacterDetail(int id) async {
    final resp = await _get('${ApiConstants.charactersEndpoint}/$id');

    return CharacterModel.fromJson(resp.data);
  }

  Future<Response> _get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        await Future.delayed(_rateLimitRetryDelay);
        return dio.get(path, queryParameters: queryParameters);
      }
      rethrow;
    }
  }
}
