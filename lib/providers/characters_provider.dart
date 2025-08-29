import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/api_services.dart';

// Proveedor para la instancia del servicio de API
final apiServiceProvider = Provider((ref) => ApiService());

// Este proveedor maneja el estado de la lista de personajes
final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCharacters();
});

// Este proveedor maneja el estado de los detalles de un personaje y la caché
class CharacterDetailsNotifier extends StateNotifier<Map<int, Character>> {
  CharacterDetailsNotifier(this.apiService) : super({});

  final ApiService apiService;

  // Método para obtener los detalles de un personaje, usando caché
  Future<Character> getCharacterDetails(int id) async {
    // Si el personaje ya está en caché, lo devuelve
    if (state.containsKey(id)) {
      return state[id]!;
    }

    // Si no está, hace la petición a la API y lo guarda en caché
    try {
      final character = await apiService.getCharacterById(id);
      state = {
        ...state,
        id: character,
      };
      return character;
    } catch (e) {
      throw Exception('Error fetching character details: $e');
    }
  }
}

// Proveedor para el notificador de detalles de personaje
final characterDetailsProvider = StateNotifierProvider<CharacterDetailsNotifier, Map<int, Character>>((ref) {
  return CharacterDetailsNotifier(ref.read(apiServiceProvider));
});
