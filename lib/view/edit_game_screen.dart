import 'package:flutter/material.dart';
import '../domain/models/edit_result.dart';
import '../domain/models/game.dart';
import 'widget/game_confirm_delete.dart';
import 'widget/game_form.dart';

class EditGameScreen extends StatelessWidget {
  const EditGameScreen({super.key, required this.game});

  final Game game;

  Future<void> _onDeletePressed(BuildContext context) async {
    final confirmed = await confirmDeleteGame(context, game);
    if (!confirmed || !context.mounted) return;
    Navigator.pop(context, const GameDeleted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus game',
            onPressed: () => _onDeletePressed(context),
          ),
        ],
      ),
      body: SafeArea(
        child: GameForm(
          initial: game,
          submitLabel: 'Simpan perubahan',
          onSubmit: (title, status) => Navigator.pop(
            context,
            GameUpdated(game.copyWith(title: title, status: status)),
          ),
        ),
      ),
    );
  }
}