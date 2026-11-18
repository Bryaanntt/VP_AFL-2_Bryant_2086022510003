import '../models/game.dart';

abstract interface class GameRepository {
  Future<List<Game>> getGames({bool refresh = false});
  Future<void> addGame(String title, GameStatus status);
  Future<void> updateGame(Game updated);
  Future<void> updateStatus(String id, GameStatus status);
  Future<void> deleteGame(String id);
}