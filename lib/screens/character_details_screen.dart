import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../providers/characters_provider.dart';

class CharacterDetailsScreen extends ConsumerWidget {
  final int characterId;
  const CharacterDetailsScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el notificador para obtener los detalles del personaje
    final characterDetailsNotifier = ref.watch(characterDetailsProvider.notifier);
    
    // Usa FutureBuilder si necesita manejar el estado de carga y error en la UI
    return FutureBuilder<Character>(
      // Llamada al método que maneja la lógica de la caché
      future: characterDetailsNotifier.getCharacterDetails(characterId),
      builder: (context, snapshot) {
        final character = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtienen los datos
          return Scaffold(
            appBar: AppBar(title: const Text('Cargando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si la petición falla
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (character != null) {
          // Muestra los detalles del personaje
          return Scaffold(
            appBar: AppBar(
              title: Text(character.name),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(character.image),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    character.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('ID: ${character.id}'),
                  Text('Especie: ${character.species}'),
                  Text('Estado: ${character.status}'),
                  Text('Género: ${character.gender}'),
                  Text('Ubicación: ${character.location.name}'),
                ],
              ),
            ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('No se encontraron datos.')),
          );
        }
      },
    );
  }
}
