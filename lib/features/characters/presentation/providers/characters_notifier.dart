import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'characters_dependency_providers.dart';
import 'characters_exception.dart';

class RmSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final characterSearchQueryProvider =
    NotifierProvider<RmSearchQueryNotifier, String>(RmSearchQueryNotifier.new);

class RmCharactersListState {
  const RmCharactersListState({
    required this.characters,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<RmCharacterEntity> characters;
  final bool hasMore;
  final bool isLoadingMore;

  RmCharactersListState copyWith({
    List<RmCharacterEntity>? characters,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return RmCharactersListState(
      characters: characters ?? this.characters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class RmCharactersNotifier extends AsyncNotifier<RmCharactersListState> {
  int _page = 1;

  Future<RmCharactersPage> _fetchPage(String name, int pageNumber) async {
    final result = await ref
        .read(getCharactersUseCaseProvider)
        .call(name: name.isEmpty ? null : name, page: pageNumber);

    return switch (result) {
      RmSuccess(value: final page) => page,
      RmFailure(message: final message) => throw RmCharactersException(message),
    };
  }

  @override
  Future<RmCharactersListState> build() async {
    _page = 1;
    final name = ref.watch(characterSearchQueryProvider);
    final page = await _fetchPage(name, _page);
    return RmCharactersListState(
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
        RmCharactersListState(
          characters: [...current.characters, ...page.characters],
          hasMore: page.hasNext,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final charactersNotifierProvider =
    AsyncNotifierProvider<RmCharactersNotifier, RmCharactersListState>(
      RmCharactersNotifier.new,
    );

final characterDetailProvider = FutureProvider.family<RmCharacterEntity, int>((
  ref,
  id,
) async {
  final result = await ref.watch(getCharacterDetailUseCaseProvider).call(id);

  return switch (result) {
    RmSuccess(value: final character) => character,
    RmFailure(message: final message) => throw RmCharactersException(message),
  };
});
