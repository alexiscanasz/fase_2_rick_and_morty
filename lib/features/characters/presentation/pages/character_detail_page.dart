import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/character_entity.dart';
import '../providers/characters_providers.dart';

class CharacterDetailPage extends ConsumerWidget {
  const CharacterDetailPage({super.key, required this.characterId});

  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterDetailProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        title: characterAsync.when(
          data: (character) => Text(character.name),
          loading: () => const Text('Cargando...'),
          error: (_, _) => const Text('Personaje'),
        ),
      ),
      body: characterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error.toString()),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(characterDetailProvider(characterId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (character) => _CharacterDetailView(character: character),
      ),
    );
  }
}

class _CharacterDetailView extends StatelessWidget {
  const _CharacterDetailView({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: character.image,
            height: 240,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const SizedBox(
              height: 240,
              child: Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(character.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: switch (character.status.toLowerCase()) {
                'alive' => Colors.green,
                'dead' => Colors.red,
                _ => Colors.grey,
              },
            ),
            const SizedBox(width: 6),
            Text('${character.status} · ${character.species}'),
          ],
        ),
        const Divider(height: 32),
        _DetailRow(label: 'Género', value: character.gender),
        _DetailRow(label: 'Origen', value: character.origin),
        _DetailRow(label: 'Última ubicación', value: character.location),
        _DetailRow(label: 'ID', value: character.id.toString()),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? 'Desconocido' : value)),
        ],
      ),
    );
  }
}
