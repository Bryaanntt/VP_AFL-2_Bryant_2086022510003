import 'package:equatable/equatable.dart';

enum GameStatus { playing, finished, dropped, backlog }

extension GameStatusLabel on GameStatus {
  String get label {
    switch (this) {
      case GameStatus.playing:
        return 'Playing';
      case GameStatus.finished:
        return 'Finished';
      case GameStatus.dropped:
        return 'Dropped';
      case GameStatus.backlog:
        return 'Backlog';
    }
  }
}

class Game extends Equatable {
  final String id;
  final String title;
  final GameStatus status;

  const Game({required this.id, required this.title, required this.status});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      status: GameStatus.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status.name,
    };
  }

  Game copyWith({String? title, GameStatus? status}) {
    return Game(
      id: id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, title, status];
}