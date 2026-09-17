import 'package:flutter/material.dart';

import '../../characters/presentation/presentation.dart';

class RmPortalRemotoApp extends StatelessWidget {
  const RmPortalRemotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fase 2 | Portal Remoto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RmCharactersListPage(),
    );
  }
}
