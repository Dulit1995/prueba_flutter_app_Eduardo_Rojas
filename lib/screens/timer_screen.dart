import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    String buttonText;
    Color buttonColor;

    if (timerState.isRunning) {
      buttonText = 'Pausar';
      buttonColor = Colors.orange;
    } else if (timerState.seconds > 0) {
      buttonText = 'Continuar';
      buttonColor = Colors.blue;
    } else {
      buttonText = 'Iniciar';
      buttonColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Tiempo'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(timerState.seconds),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (timerState.startTime != null)
              Text(
                'Iniciado: ${DateFormat('HH:mm:ss').format(timerState.startTime!)}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timerNotifier.toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                if (timerState.seconds > 0) const SizedBox(width: 20),
                if (timerState.seconds > 0)
                  ElevatedButton(
                    onPressed: timerNotifier.resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Finalizar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
