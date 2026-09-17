import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import '../providers/characters_notifier.dart';
import 'character_detail_page.dart';

class RmCharactersListPage extends ConsumerStatefulWidget {
  const RmCharactersListPage({super.key});

  @override
  ConsumerState<RmCharactersListPage> createState() =>
      _RmCharactersListPageState();
}

class _RmCharactersListPageState extends ConsumerState<RmCharactersListPage> {
  static const _loadMoreThreshold = 300.0;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(charactersNotifierProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(characterSearchQueryProvider.notifier).update(value.trim());
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(charactersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Buscar personaje por nombre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: charactersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _RmCharactersErrorView(message: error.toString()),
              data: (state) => state.characters.isEmpty
                  ? const _RmCharactersEmptyView()
                  : _RmCharactersListView(
                      characters: state.characters,
                      isLoadingMore: state.isLoadingMore,
                      scrollController: _scrollController,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RmCharactersListView extends StatelessWidget {
  const _RmCharactersListView({
    required this.characters,
    required this.isLoadingMore,
    required this.scrollController,
  });

  final List<RmCharacterEntity> characters;
  final bool isLoadingMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: characters.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= characters.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final character = characters[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(character.image),
            ),
            title: Text(character.name),
            subtitle: Text(
              '${character.status.name} · ${character.species.name}',
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    RmCharacterDetailPage(characterId: character.id),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RmCharactersEmptyView extends StatelessWidget {
  const _RmCharactersEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No se encontraron personajes'));
  }
}

class _RmCharactersErrorView extends StatelessWidget {
  const _RmCharactersErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) => FilledButton(
              onPressed: () => ref.invalidate(charactersNotifierProvider),
              child: const Text('Reintentar'),
            ),
          ),
        ],
      ),
    );
  }
}
