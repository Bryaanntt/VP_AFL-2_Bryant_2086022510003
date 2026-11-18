import 'dart:convert';
import '../../domain/models/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../service/game_service.dart';
class GameRepositoryImplements implements GameRepository {
  GameRepositoryImplements(this._service);

  final GameService _service;
  List<Game>? _games; // null = belum pernah diambil

  @override
  Future<List<Game>> getGames({bool refresh = false}) async {
    if (_games == null || refresh) {
      final raw = await _service.loadGamesJson();
      final decoded = jsonDecode(raw) as List<dynamic>;
      _games = decoded
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return List<Game>.of(_games!);
  }

  Future<void> _persist() async {
    final games = _games;
    if (games == null) return;
    final encoded = jsonEncode(games.map((g) => g.toJson()).toList());
    await _service.saveGamesJson(encoded);
  }

  @override
  Future<void> addGame(String title, GameStatus status) async {
    final games = _games ??= [];
    final game = Game(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      status: status,
    );
    games.insert(0, game);
    await _persist();
  }

  @override
  Future<void> updateGame(Game updated) async {
    final games = _games;
    if (games == null) return;
    final index = games.indexWhere((g) => g.id == updated.id);
    if (index == -1) return;
    games[index] = updated.copyWith(title: updated.title.trim());
    await _persist();
  }

  @override
  Future<void> updateStatus(String id, GameStatus status) async {
    final games = _games;
    if (games == null) return;
    final index = games.indexWhere((g) => g.id == id);
    if (index == -1) return;
    games[index] = games[index].copyWith(status: status);
    await _persist();
  }

  @override
  Future<void> deleteGame(String id) async {
    final games = _games;
    if (games == null) return;
    games.removeWhere((g) => g.id == id);
    await _persist();
  }
}