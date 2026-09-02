import 'package:equatable/equatable.dart';

import '../../domain/entities/character_entity.dart';

sealed class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object?> get props => [];
}

class CharactersInitial extends CharactersState {
  const CharactersInitial();
}

class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

class CharactersLoaded extends CharactersState {
  const CharactersLoaded(this.characters);

  final List<Character> characters;

  @override
  List<Object?> get props => [characters];
}

class CharactersError extends CharactersState {
  const CharactersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
