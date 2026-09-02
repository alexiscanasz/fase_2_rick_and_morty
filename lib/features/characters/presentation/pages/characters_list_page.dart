import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character_entity.dart';
import '../bloc/characters_bloc.dart';
import '../bloc/characters_event.dart';
import '../bloc/characters_state.dart';

class CharactersListPage extends StatelessWidget {
  const CharactersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty')),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          return switch (state) {
            CharactersInitial() || CharactersLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CharactersLoaded(characters: final characters) =>
              _CharactersListView(characters: characters),
            CharactersError(message: final message) => _CharactersErrorView(
              message: message,
            ),
          };
        },
      ),
    );
  }
}

class _CharactersListView extends StatelessWidget {
  const _CharactersListView({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(character.image)),
          title: Text(character.name),
          subtitle: Text('${character.status} · ${character.species}'),
        );
      },
    );
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
          FilledButton(
            onPressed: () =>
                context.read<CharactersBloc>().add(const LoadCharacters()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
