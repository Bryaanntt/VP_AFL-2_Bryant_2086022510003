import 'package:equatable/equatable.dart';
import 'game.dart';

sealed class EditResult extends Equatable {
  const EditResult();

  @override
  List<Object?> get props => [];
}

final class GameUpdated extends EditResult {
  const GameUpdated(this.game);
  final Game game;

  @override
  List<Object?> get props => [game];
}

final class GameDeleted extends EditResult {
  const GameDeleted();
}