import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../providers/characters_provider.dart';
import 'character_details_screen.dart';

class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes'),
        centerTitle: true,
      ),
      body: charactersAsync.when(
        data: (characters) {
          // Muestra la lista de personajes si los datos están disponibles
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterListItem(character: character);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}

// Widget de un solo item en la lista
class CharacterListItem extends ConsumerWidget {
  final Character character;
  const CharacterListItem({super.key, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(character.image),
          onBackgroundImageError: (exception, stackTrace) {
            // Maneja el error si la imagen no se carga
            print('Error al cargar la imagen: $exception');
          },
        ),
        title: Text(
          character.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Especie: ${character.species}'),
            Text('Episodio: ${character.episode.first.split('/').last}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CharacterDetailsScreen(characterId: character.id),
            ),
          );
        },
      ),
    );
  }
}
