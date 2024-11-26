import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GuessNumberGame());
}

class GuessNumberGame extends StatelessWidget {
  const GuessNumberGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the Number',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => GameBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}
