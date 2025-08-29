import 'package:dio/dio.dart';
import '../models/character.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  // Obtiene el listado de todos los personajes
  Future<List<Character>> getCharacters() async {
    try {
      final response = await _dio.get('$_baseUrl/character');
      final results = response.data['results'] as List;
      return results.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  // Obtiene los detalles de un solo personaje por su ID
  Future<Character> getCharacterById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/character/$id');
      return Character.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load character with id $id: $e');
    }
  }
}
