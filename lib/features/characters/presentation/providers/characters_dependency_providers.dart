import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final characterRemoteDatasourceProvider = Provider<RmCharacterRemoteDatasource>(
  (ref) => RmCharacterRemoteDatasourceImpl(dio: ref.watch(dioProvider)),
);

final charactersRepositoryProvider = Provider<RmCharactersRepository>(
  (ref) => RmCharactersRepositoryImpl(
    characterRemoteDatasource: ref.watch(characterRemoteDatasourceProvider),
  ),
);

final getCharactersUseCaseProvider = Provider<RmGetCharactersUseCase>(
  (ref) => RmGetCharactersUseCase(
    repository: ref.watch(charactersRepositoryProvider),
  ),
);

final getCharacterDetailUseCaseProvider = Provider<RmGetCharacterDetailUseCase>(
  (ref) => RmGetCharacterDetailUseCase(
    repository: ref.watch(charactersRepositoryProvider),
  ),
);
