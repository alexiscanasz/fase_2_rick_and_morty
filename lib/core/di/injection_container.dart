import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/characters/data/datasources/character_local_datasource.dart';
import '../../features/characters/data/datasources/character_remote_datasource.dart';
import '../../features/characters/data/repositories/character_repository_impl.dart';
import '../../features/characters/domain/repositories/characters_repository.dart';
import '../../features/characters/domain/use_cases/add_character_to_favorite_use_case.dart';
import '../../features/characters/domain/use_cases/get_character_detail_use_case.dart';
import '../../features/characters/domain/use_cases/get_characters_use_case.dart';
import '../../features/characters/domain/use_cases/get_favorite_characters_use_case.dart';
import '../../features/characters/presentation/bloc/characters_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton<Dio>(() => Dio());

  // Datasources
  sl.registerLazySingleton<CharacterRemoteDatasource>(
    () => CharacterRemoteDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CharacterLocalDatasource>(
    () => HiveCharacterLocalDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(
      characterRemoteDatasource: sl(),
      characterLocalDatasource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCharactersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCharacterDetailUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => AddCharacterToFavoriteUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetFavoriteCharactersUseCase(repository: sl()),
  );

  // Bloc
  sl.registerFactory(() => CharactersBloc(getCharactersUseCase: sl()));
}
