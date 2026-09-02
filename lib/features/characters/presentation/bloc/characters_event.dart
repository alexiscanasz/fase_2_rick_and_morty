import 'package:equatable/equatable.dart';

sealed class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharactersEvent {
  const LoadCharacters();
}
