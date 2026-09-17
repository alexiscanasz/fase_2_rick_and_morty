import 'package:equatable/equatable.dart';

import 'character_species.dart';
import 'character_status.dart';

/// Representa un personaje de rick and morty en la capa de dominio, con los
/// datos ya normalizados (independiente del formato JSON de la API)
class RmCharacterEntity extends Equatable {
  final int id;
  final String name;
  final RmCharacterStatus status;
  final RmCharacterSpecies species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  const RmCharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    gender,
    origin,
    location,
    image,
  ];
}
