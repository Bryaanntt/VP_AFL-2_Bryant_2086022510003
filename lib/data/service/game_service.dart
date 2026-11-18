import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  static const _key = 'games_data';

  Future<String> loadGamesJson() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null && saved.trim().isNotEmpty) return saved;

    final seed = await rootBundle.loadString('lib/features/game.json');
    await prefs.setString(_key, seed);
    return seed;
  }

  Future<void> saveGamesJson(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonString);
  }
}