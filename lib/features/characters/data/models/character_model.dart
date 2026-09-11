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
}
