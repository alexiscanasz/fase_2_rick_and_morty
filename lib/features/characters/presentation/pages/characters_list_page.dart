import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/character_entity.dart';
import '../providers/characters_providers.dart';
import 'character_detail_page.dart';

class CharactersListPage extends ConsumerStatefulWidget {
  const CharactersListPage({super.key});

  @override
  ConsumerState<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends ConsumerState<CharactersListPage> {
  static const _loadMoreThreshold = 300.0;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

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
              error: (error, _) => _CharactersErrorView(message: error.toString()),
              data: (state) => state.characters.isEmpty
                  ? const _CharactersEmptyView()
                  : _CharactersListView(
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

class _CharactersListView extends StatelessWidget {
  const _CharactersListView({
    required this.characters,
    required this.isLoadingMore,
    required this.scrollController,
  });

  final List<Character> characters;
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
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(character.image),
          ),
          title: Text(character.name),
          subtitle: Text('${character.status} · ${character.species}'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CharacterDetailPage(characterId: character.id),
            ),
          ),
        );
      },
    );
  }
}

class _CharactersEmptyView extends StatelessWidget {
  const _CharactersEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No se encontraron personajes'));
  }
}

class _CharactersErrorView extends StatelessWidget {
  const _CharactersErrorView({required this.message});

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
