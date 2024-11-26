import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? maxNumber;

  final TextEditingController _nController = TextEditingController();
  final TextEditingController _mController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                final isGameInProgress = state is GameInProgress;
                final color = state is GameWon
                    ? const Color(0xFF4CAF50) // Зеленый при победе
                    : state is GameLost
                    ? const Color(0xFFF44336) // Красный при проигрыше
                    : const Color(0xFF073042); // Стандартный цвет

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isGameInProgress || state is GameWon || state is GameLost
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  color: color,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Угадай число",
                            style: TextStyle(
                              fontSize: isGameInProgress || state is GameWon || state is GameLost ? 24 : 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEBF0DC),
                              fontFamily: "Pacifico-Regular",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (!(isGameInProgress || state is GameWon || state is GameLost)) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF7CF),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: const Text(
                                    "Приветствую вас в увлекательной игре \"Угадай число\"! Это приложение, в котором вы можете проверить свою интуицию и навыки логического мышления. \n"
                                        "Приложение загадывает случайное число из диапазона n. Ваша задача — угадать его за m попыток.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF073042),
                                      fontFamily: "RobotoMono-Medium",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state is GameInitial) {
                  return _buildSetupScreen(context);
                } else if (state is GameInProgress) {
                  return _buildGameScreen(context, state);
                } else if (state is GameWon) {
                  print("Состояние: GameWon");
                  return _buildEndScreen(context, "Ты выиграл! Молодчинка! 🎉");
                } else if (state is GameLost) {
                  print("Состояние: GameLost");
                  return _buildEndScreen(
                    context,
                    "Эхх, в следующий раз повезет. Загаданным числом было: ${state.correctNumber}",
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Выберите диапазон (n), в котором я загадаю число.",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF073042),
              fontFamily: "Roboto-Medium"
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key("maxNumberField"),
            controller: _nController,
            decoration: InputDecoration(
              labelText: "Введите число (n)",
              filled: true,
              fillColor: const Color(0xFFEDDEE8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFCABBC5), width: 1.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text(
            "Теперь выберите количество попыток (m).",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF073042),
                fontFamily: "Roboto-Medium"
            ),
          ),
          const Text(
            "(Число m не должно быть больше или равно числу n!)",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF949494),
              fontFamily: "Roboto-Regular"
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key("maxAttemptField"),
            controller: _mController,
            decoration: InputDecoration(
              labelText: "Введите количество попыток (m)",
              filled: true,
              fillColor: Color(0xFFEDDEE8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFCABBC5), width: 1.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(_nController.text);
              final m = int.tryParse(_mController.text);

              if (n == null || m == null || m >= n) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Извините, повторите заполнив все правильно!"),
                  ),
                );
              } else {
                context.read<GameBloc>().add(StartGame(n, m));
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFFEFF7CF),
              backgroundColor: const Color(0xFF073042),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text("Сгенерировать число"),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen(BuildContext context, GameInProgress state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
        child: Column(
          children: [
            Text(
                "Осталось попыток: ${state.remainingAttempts}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF073042),
                  fontFamily: "Roboto-Medium"
                )
            ),
            if (state.feedback.isNotEmpty)
              Text(
                state.feedback,
                style: const TextStyle(
                  color: Color(0xFF949494),
                  fontSize: 16,
                  fontFamily: "RobotoMono-Regular"
                )
              ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Введи своё число",
                filled: true,
                fillColor: Color(0xFFEDDEE8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFCABBC5), width: 1.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final guess = int.tryParse(value);
                if (guess != null) {
                  context.read<GameBloc>().add(MakeGuess(guess));
                }
              },
            ),
          ],
        ),
    );
  }

  Widget _buildEndScreen(BuildContext context, String message) {
    final color = message.contains("выиграл") ? const Color(0xFF4CAF50) : const Color(0xFFF44336);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFF073042),
            fontFamily: "Roboto-Medium",
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            context.read<GameBloc>().add(RestartGame());
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFFEFF7CF),
            backgroundColor: const Color(0xFF073042),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text("Желаете начать заново?"),
        ),
      ],
    );
  }
}