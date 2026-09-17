import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../models/character_model.dart';

abstract interface class RmCharacterRemoteDatasource {
  Future<RmCharactersPage> getCharacters({String? name, int page = 1});
  Future<RmCharacterModel> getCharacterDetail(int id);
}

class RmCharacterRemoteDatasourceImpl implements RmCharacterRemoteDatasource {
  RmCharacterRemoteDatasourceImpl({required this.dio});

  static const _rateLimitRetryDelay = Duration(milliseconds: 1500);

  final Dio dio;

  Future<Response> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
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

  @override
  Future<RmCharactersPage> getCharacters({String? name, int page = 1}) async {
    try {
      final resp = await _get(
        RmApiConstants.charactersEndpoint,
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
          'page': page,
        },
      );

      final characters = RmCharacterModel.listFromJson(resp.data);
      final hasNext = (resp.data as Map?)?['info']?['next'] != null;
      return RmCharactersPage(characters: characters, hasNext: hasNext);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const RmCharactersPage(characters: [], hasNext: false);
      }
      rethrow;
    }
  }

  @override
  Future<RmCharacterModel> getCharacterDetail(int id) async {
    final resp = await _get('${RmApiConstants.charactersEndpoint}/$id');

    return RmCharacterModel.fromJson(resp.data);
  }
}
