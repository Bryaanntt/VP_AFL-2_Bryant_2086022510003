import 'package:flutter/material.dart';
import '../domain/models/game.dart';
import '../viewmodel/game_backlog_viewmodel.dart';
import 'widget/game_form.dart';

class AddGameView extends StatelessWidget {
  const AddGameView({super.key, required this.viewModel});

  final GameBacklogViewModel viewModel;

  Future<void> _submit(BuildContext context, String title, GameStatus status) async {
    await viewModel.addGame(title, status);
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Game')),
      body: SafeArea(
        child: GameForm(
          submitLabel: 'Simpan',
          onSubmit: (title, status) => _submit(context, title, status),
        ),
      ),
    );
  }
}