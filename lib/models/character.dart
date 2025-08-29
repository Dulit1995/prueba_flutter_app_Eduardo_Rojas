import 'package:freezed_annotation/freezed_annotation.dart';
part 'character.freezed.dart';
part 'character.g.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required int id,
    required String name,
    required String status,
    required String species,
    required String gender,
    required String image,
    required Location location,
    @JsonKey(name: 'episode') required List<String> episode,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({
    required String name,
    required String url,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
