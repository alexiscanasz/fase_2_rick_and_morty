import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/use_cases/get_characters_use_case.dart';
import 'characters_event.dart';
import 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc({required this.getCharactersUseCase})
    : super(const CharactersInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
  }

  final GetCharactersUseCase getCharactersUseCase;

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    emit(const CharactersLoading());
    final result = await getCharactersUseCase();
    switch (result) {
      case Success(value: final characters):
        emit(CharactersLoaded(characters));
      case Failure(message: final message):
        emit(CharactersError(message));
    }
  }
}
