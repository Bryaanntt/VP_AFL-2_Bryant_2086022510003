import 'package:flutter/material.dart';
import '../../domain/models/game.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({
    super.key,
    required this.game,
    required this.onTap,
    required this.onStatusChanged,
  });

  final Game game;
  final VoidCallback onTap;
  final ValueChanged<GameStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.videogame_asset_outlined, color: scheme.primary),
      title: Text(game.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(game.status.label),
      trailing: PopupMenuButton<GameStatus>(
        tooltip: 'Ubah status',
        icon: const Icon(Icons.swap_horiz),
        initialValue: game.status,
        onSelected: onStatusChanged,
        itemBuilder: (_) => GameStatus.values
            .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
            .toList(),
      ),
    );
  }
}