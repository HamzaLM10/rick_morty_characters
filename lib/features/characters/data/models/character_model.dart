import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';

/// Knows the JSON shape of the API. Converts itself to a domain [Character].
class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.lastLocation,
    required this.imageUrl,
    required this.episodeCount,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: (json['origin'] as Map<String, dynamic>)['name'] as String,
      lastLocation:
          (json['location'] as Map<String, dynamic>)['name'] as String,
      imageUrl: json['image'] as String,
      episodeCount: (json['episode'] as List<dynamic>).length,
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String lastLocation;
  final String imageUrl;
  final int episodeCount;

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin,
      lastLocation: lastLocation,
      imageUrl: imageUrl,
      episodeCount: episodeCount,
    );
  }
}
