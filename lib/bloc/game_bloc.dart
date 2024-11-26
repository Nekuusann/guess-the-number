import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {
  final int maxNumber;
  final int attempts;

  StartGame(this.maxNumber, this.attempts);

  @override
  List<Object?> get props => [maxNumber, attempts];
}

class MakeGuess extends GameEvent {
  final int guessedNumber;

  MakeGuess(this.guessedNumber);

  @override
  List<Object?> get props => [guessedNumber];
}

class RestartGame extends GameEvent {}

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final int remainingAttempts;
  final String feedback;

  GameInProgress(this.remainingAttempts, {this.feedback = ''});

  @override
  List<Object?> get props => [remainingAttempts, feedback];
}

class GameWon extends GameState {}

class GameLost extends GameState {
  final int correctNumber;

  GameLost({required this.correctNumber});

  @override
  List<Object?> get props => [correctNumber];
}

class GameBloc extends Bloc<GameEvent, GameState> {
  int? _targetNumber;
  int? _remainingAttempts;

  GameBloc() : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<MakeGuess>(_onMakeGuess);
    on<RestartGame>(_onRestartGame);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    if (event.maxNumber <= 0) throw ArgumentError("maxNumber должен быть больше 0");

    final random = Random();
    _targetNumber = random.nextInt(event.maxNumber) + 1;
    _remainingAttempts = event.attempts;

    print('Игра началась. Загаданное число: $_targetNumber');
    emit(GameInProgress(_remainingAttempts!));
  }

  void _onMakeGuess(MakeGuess event, Emitter<GameState> emit) {
    if (_targetNumber == null || _remainingAttempts == null) return;

    _remainingAttempts = _remainingAttempts! - 1;

    if (event.guessedNumber == _targetNumber) {
      emit(GameWon());
    } else if (_remainingAttempts == 0) {
      emit(GameLost(correctNumber: _targetNumber!));
    } else {
      final feedback = event.guessedNumber > _targetNumber!
          ? 'Загаданное число меньше!'
          : 'Загаданное число больше';
      emit(GameInProgress(_remainingAttempts!, feedback: feedback));
    }
  }

  void _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    _targetNumber = null;
    _remainingAttempts = null;
    print('Игра перезапущена.');
    emit(GameInitial());
  }
}