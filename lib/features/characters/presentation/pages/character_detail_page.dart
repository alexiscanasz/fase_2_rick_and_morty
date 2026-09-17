import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import '../providers/characters_notifier.dart';

class RmCharacterDetailPage extends ConsumerWidget {
  const RmCharacterDetailPage({super.key, required this.characterId});

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
        data: (character) => _RmCharacterDetailView(character: character),
      ),
    );
  }
}

class _RmCharacterDetailView extends StatelessWidget {
  const _RmCharacterDetailView({required this.character});

  final RmCharacterEntity character;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 240,
              height: 240,
              child: Image.network(
                character.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
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
              color: switch (character.status) {
                RmCharacterStatus.alive => Colors.green,
                RmCharacterStatus.dead => Colors.red,
                RmCharacterStatus.unknown => Colors.grey,
              },
            ),
            const SizedBox(width: 6),
            Text('${character.status.name} · ${character.species.name}'),
          ],
        ),
        const Divider(height: 32),
        _RmDetailRow(label: 'Género', value: character.gender),
        _RmDetailRow(label: 'Origen', value: character.origin),
        _RmDetailRow(label: 'Última ubicación', value: character.location),
        _RmDetailRow(label: 'ID', value: character.id.toString()),
      ],
    );
  }
}

class _RmDetailRow extends StatelessWidget {
  const _RmDetailRow({required this.label, required this.value});

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
