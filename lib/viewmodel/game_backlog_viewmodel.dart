import 'package:flutter/foundation.dart';
import '../data/repositories/game_repository_implements.dart';
import '../data/service/game_service.dart';
import '../domain/models/edit_result.dart';
import '../domain/models/game.dart';
import '../domain/repositories/game_repository.dart';
import 'game_backlog_state.dart';

class GameBacklogViewModel extends ChangeNotifier {
  GameBacklogViewModel([GameRepository? repository])
      : _repository = repository ?? GameRepositoryImplements(GameService());

  final GameRepository _repository;
  bool _disposed = false;

  GameBacklogState _state = const GameBacklogLoading();
  GameBacklogState get state => _state;

  GameStatus? get _currentFilter {
    final current = _state;
    return current is GameBacklogLoaded ? current.selectedStatus : null;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> load({bool refresh = false}) async {
    final filter = _currentFilter;
    _state = const GameBacklogLoading();
    notifyListeners();

    try {
      final games = await _repository.getGames(refresh: refresh);
      if (_disposed) return;
      _state = GameBacklogLoaded(games: games, selectedStatus: filter);
    } catch (_) {
      if (_disposed) return;
      _state = const GameBacklogError('Gagal memuat daftar game');
    }

    notifyListeners();
  }

  Future<void> addGame(String title, GameStatus status) async {
    final filter = _currentFilter;
    await _repository.addGame(title, status);
    final games = await _repository.getGames();
    if (_disposed) return;
    _state = GameBacklogLoaded(games: games, selectedStatus: filter);
    notifyListeners();
  }

  Future<void> updateGame(Game updated) async {
    final filter = _currentFilter;
    await _repository.updateGame(updated);
    final games = await _repository.getGames();
    if (_disposed) return;
    _state = GameBacklogLoaded(games: games, selectedStatus: filter);
    notifyListeners();
  }

  Future<void> changeStatus(Game game, GameStatus status) async {
    final filter = _currentFilter;
    await _repository.updateStatus(game.id, status);
    final games = await _repository.getGames();
    if (_disposed) return;
    _state = GameBacklogLoaded(games: games, selectedStatus: filter);
    notifyListeners();
  }

  Future<void> deleteGame(String id) async {
    final filter = _currentFilter;
    await _repository.deleteGame(id);
    final games = await _repository.getGames();
    if (_disposed) return;
    _state = GameBacklogLoaded(games: games, selectedStatus: filter);
    notifyListeners();
  }

  Future<void> handleEditResult(String originalId, EditResult? result) async {
    switch (result) {
      case GameUpdated(:final game):
        await updateGame(game);
      case GameDeleted():
        await deleteGame(originalId);
      case null:
        break;
    }
  }

  void selectStatus(GameStatus? status) {
    final current = _state;
    if (current is GameBacklogLoaded) {
      _state = GameBacklogLoaded(
        games: current.games,
        selectedStatus: status,
      );
      notifyListeners();
    }
  }
}