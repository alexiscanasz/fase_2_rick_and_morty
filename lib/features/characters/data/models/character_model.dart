import '../../domain/domain.dart';

class RmCharacterModel extends RmCharacterEntity {
  static const _idKey = 'id';
  static const _nameKey = 'name';
  static const _statusKey = 'status';
  static const _speciesKey = 'species';
  static const _genderKey = 'gender';
  static const _originKey = 'origin';
  static const _locationKey = 'location';
  static const _imageKey = 'image';
  static const _resultsKey = 'results';

  static RmCharacterStatus _parseStatus(String? value) {
    return switch (value?.toLowerCase()) {
      'alive' => RmCharacterStatus.alive,
      'dead' => RmCharacterStatus.dead,
      _ => RmCharacterStatus.unknown,
    };
  }

  static RmCharacterSpecies _parseSpecies(String? value) {
    return switch (value?.toLowerCase()) {
      'human' => RmCharacterSpecies.human,
      'alien' => RmCharacterSpecies.alien,
      'humanoid' => RmCharacterSpecies.humanoid,
      'poopybutthole' => RmCharacterSpecies.poopybutthole,
      'mythological creature' => RmCharacterSpecies.mythologicalCreature,
      'animal' => RmCharacterSpecies.animal,
      'robot' => RmCharacterSpecies.robot,
      'cronenberg' => RmCharacterSpecies.cronenberg,
      'disease' => RmCharacterSpecies.disease,
      _ => RmCharacterSpecies.unknown,
    };
  }

  const RmCharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
  });

  RmCharacterModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json[_idKey] as int,
        name: json[_nameKey] as String,
        status: _parseStatus(json[_statusKey] as String?),
        species: _parseSpecies(json[_speciesKey] as String?),
        gender: json[_genderKey] as String,
        origin:
            (json[_originKey] as Map<String, dynamic>?)?[_nameKey] as String? ??
            '',
        location:
            (json[_locationKey] as Map<String, dynamic>?)?[_nameKey]
                as String? ??
            '',
        image: json[_imageKey] as String,
      );

  static List<RmCharacterModel> listFromJson(Map<String, dynamic> json) =>
      ((json[_resultsKey] as List?) ?? const [])
          .map(
            (character) =>
                RmCharacterModel.fromJson(character as Map<String, dynamic>),
          )
          .toList();
}
