import 'package:flutter/material.dart';
import '../../domain/models/game.dart';

Future<bool> confirmDeleteGame(BuildContext context, Game game) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hapus game?'),
      content: Text('Yakin ingin menghapus "${game.title}" dari backlog?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return result ?? false;
}