import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'features/characters/presentation/bloc/characters_bloc.dart';
import 'features/characters/presentation/bloc/characters_event.dart';
import 'features/characters/presentation/pages/characters_list_page.dart';

void main() {
  initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 2 | Portal Remoto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => sl<CharactersBloc>()..add(const LoadCharacters()),
        child: const CharactersListPage(),
      ),
    );
  }
}
