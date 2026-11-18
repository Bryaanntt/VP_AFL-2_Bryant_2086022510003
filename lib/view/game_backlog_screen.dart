import 'package:flutter/material.dart';
import '../domain/models/edit_result.dart';
import '../domain/models/game.dart';
import '../viewmodel/game_backlog_state.dart';
import '../viewmodel/game_backlog_viewmodel.dart';
import 'add_game_screen.dart';
import 'edit_game_screen.dart';
import 'widget/game_list_item.dart';

class GameBacklogView extends StatefulWidget {
  const GameBacklogView({super.key});

  @override
  State<GameBacklogView> createState() => _GameBacklogViewState();
}

class _GameBacklogViewState extends State<GameBacklogView> {
  late final GameBacklogViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameBacklogViewModel()..load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openAddGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddGameView(viewModel: _viewModel)),
    );
  }

  Future<void> _openEditGame(Game game) async {
    final result = await Navigator.push<EditResult>(
      context,
      MaterialPageRoute(builder: (_) => EditGameScreen(game: game)),
    );
    await _viewModel.handleEditResult(game.id, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backlog Kamu')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddGame,
        tooltip: 'Tambah game',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_viewModel.state) {
      GameBacklogLoading() => const Center(child: CircularProgressIndicator()),
      GameBacklogError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _viewModel.load(refresh: true),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      GameBacklogLoaded(:final filteredGames, :final selectedStatus) => Column(
          children: [
            _StatusFilter(
              selected: selectedStatus,
              onChanged: _viewModel.selectStatus,
            ),
            Expanded(
              child: filteredGames.isEmpty
                  ? const Center(child: Text('Belum ada game di sini'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: filteredGames.length,
                      itemBuilder: (context, index) {
                        final game = filteredGames[index];
                        return GameListItem(
                          game: game,
                          onTap: () => _openEditGame(game),
                          onStatusChanged: (status) =>
                              _viewModel.changeStatus(game, status),
                        );
                      },
                    ),
            ),
          ],
        ),
    };
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.selected, required this.onChanged});

  final GameStatus? selected;
  final ValueChanged<GameStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: selected == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final status in GameStatus.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(status.label),
              selected: selected == status,
              onSelected: (_) => onChanged(status),
            ),
          ],
        ],
      ),
    );
  }
}