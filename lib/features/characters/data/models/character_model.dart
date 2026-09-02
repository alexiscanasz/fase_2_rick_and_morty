import '../../domain/entities/character_entity.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
  });

  factory CharacterModel.fromJson(dynamic json) => CharacterModel(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    species: json["species"],
    gender: json["gender"],
    origin: json["origin"]?["name"] ?? '',
    location: json["location"]?["name"] ?? '',
    image: json["image"],
  );

  static List<CharacterModel> listFromJson(dynamic json) =>
      ((json["results"] as List?) ?? const [])
          .map((character) => CharacterModel.fromJson(character))
          .toList();

  factory CharacterModel.fromEntity(Character character) => CharacterModel(
    id: character.id,
    name: character.name,
    status: character.status,
    species: character.species,
    gender: character.gender,
    origin: character.origin,
    location: character.location,
    image: character.image,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'gender': gender,
    'origin': {'name': origin},
    'location': {'name': location},
    'image': image,
  };
}
