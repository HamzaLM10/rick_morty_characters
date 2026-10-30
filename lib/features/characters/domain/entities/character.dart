import 'package:equatable/equatable.dart';

class Character extends Equatable {
  const Character({
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

  final int id;
  final String name;
  final String status;
  final String species;

  /// Sub-species. Can be an empty string.
  final String type;
  final String gender;

  /// Name of the origin location.
  final String origin;

  /// Name of the last known location.
  final String lastLocation;
  final String imageUrl;
  final int episodeCount;

  bool get hasType => type.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    type,
    gender,
    origin,
    lastLocation,
    imageUrl,
    episodeCount,
  ];
}
