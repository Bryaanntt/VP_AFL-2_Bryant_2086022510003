import 'package:equatable/equatable.dart';
import '../domain/models/game.dart';

sealed class GameBacklogState extends Equatable {
  const GameBacklogState();

  @override
  List<Object?> get props => [];
}

final class GameBacklogLoading extends GameBacklogState {
  const GameBacklogLoading();
}

final class GameBacklogLoaded extends GameBacklogState {
  const GameBacklogLoaded({
    required this.games,
    this.selectedStatus,
  });

  final List<Game> games;
  final GameStatus? selectedStatus;

  List<Game> get filteredGames {
    if (selectedStatus == null) return games;
    return games.where((g) => g.status == selectedStatus).toList();
  }

  @override
  List<Object?> get props => [games, selectedStatus];
}

final class GameBacklogError extends GameBacklogState {
  const GameBacklogError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}