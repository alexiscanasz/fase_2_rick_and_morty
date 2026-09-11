import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/entities/characters_page.dart';
import '../../domain/repositories/characters_repository.dart';
import '../../domain/use_cases/get_character_detail_use_case.dart';
import '../../domain/use_cases/get_characters_use_case.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final characterRemoteDatasourceProvider = Provider<CharacterRemoteDatasource>(
  (ref) => CharacterRemoteDatasourceImpl(dio: ref.watch(dioProvider)),
);

final charactersRepositoryProvider = Provider<CharactersRepository>(
  (ref) => CharactersRepositoryImpl(
    characterRemoteDatasource: ref.watch(characterRemoteDatasourceProvider),
  ),
);

final getCharactersUseCaseProvider = Provider<GetCharactersUseCase>(
  (ref) =>
      GetCharactersUseCase(repository: ref.watch(charactersRepositoryProvider)),
);

final getCharacterDetailUseCaseProvider = Provider<GetCharacterDetailUseCase>(
  (ref) => GetCharacterDetailUseCase(
    repository: ref.watch(charactersRepositoryProvider),
  ),
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final characterSearchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class CharactersException implements Exception {
  CharactersException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CharactersListState {
  const CharactersListState({
    required this.characters,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Character> characters;
  final bool hasMore;
  final bool isLoadingMore;

  CharactersListState copyWith({
    List<Character>? characters,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CharactersListState(
      characters: characters ?? this.characters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CharactersNotifier extends AsyncNotifier<CharactersListState> {
  int _page = 1;

  @override
  Future<CharactersListState> build() async {
    _page = 1;
    final name = ref.watch(characterSearchQueryProvider);
    final page = await _fetchPage(name, _page);
    return CharactersListState(
      characters: page.characters,
      hasMore: page.hasNext,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    final name = ref.read(characterSearchQueryProvider);
    try {
      final page = await _fetchPage(name, _page + 1);
      _page += 1;
      state = AsyncData(
        CharactersListState(
          characters: [...current.characters, ...page.characters],
          hasMore: page.hasNext,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<CharactersPage> _fetchPage(String name, int pageNumber) async {
    final result = await ref
        .read(getCharactersUseCaseProvider)
        .call(name: name.isEmpty ? null : name, page: pageNumber);

    return switch (result) {
      Success(value: final page) => page,
      Failure(message: final message) => throw CharactersException(message),
    };
  }
}

final charactersNotifierProvider =
    AsyncNotifierProvider<CharactersNotifier, CharactersListState>(
      CharactersNotifier.new,
    );

final characterDetailProvider = FutureProvider.family<Character, int>((
  ref,
  id,
) async {
  final result = await ref.watch(getCharacterDetailUseCaseProvider).call(id);

  return switch (result) {
    Success(value: final character) => character,
    Failure(message: final message) => throw CharactersException(message),
  };
});
