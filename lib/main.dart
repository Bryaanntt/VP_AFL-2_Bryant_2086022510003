import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'view/game_backlog_screen.dart';

void main() => runApp(const GameBacklogApp());

class GameBacklogApp extends StatelessWidget {
  const GameBacklogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Backlog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const GameBacklogView(),
    );
  }
}