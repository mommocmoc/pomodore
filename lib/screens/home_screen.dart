import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  static int defaultSeconds = 1500;
  int totalSeconds = defaultSeconds;
  int totalPomodoros = 0;
  bool isTimerRunning = false;
  bool isAudioLoaded = false;
  late Timer timer;

  onTick(Timer timer) {
    if (totalSeconds == 0) {
      timer.cancel();
      setState(() {
        totalPomodoros++;
        isTimerRunning = false;
        totalSeconds = defaultSeconds;
        player.resume();
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  LoadAudioAsset() async {
    if (!isAudioLoaded) {
      return await player
          .setSource(AssetSource('audio/timer-done.wav'))
          .then((value) => isAudioLoaded = true);
    }
  }

  onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    LoadAudioAsset();
    setState(() {
      isTimerRunning = true;
    });
  }

  onPausePressed() {
    timer.cancel();
    setState(() {
      isTimerRunning = false;
    });
  }

  onResetPressed() {
    timer.cancel();
    setState(() {
      isTimerRunning = false;
      totalSeconds = defaultSeconds;
    });
  }

  onResetPomodoroPressed() {
    setState(() {
      totalPomodoros = 0;
    });
  }

  formatSecToMin(int seconds) {
    var durations = Duration(seconds: totalSeconds);
    var formatedDurations = durations.toString().split(".").first.substring(2);
    return formatedDurations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                formatSecToMin(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isTimerRunning ? onPausePressed : onStartPressed,
                    icon: Icon(
                      isTimerRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                  ),
                  totalSeconds < defaultSeconds
                      ? IconButton(
                          onPressed: onResetPressed,
                          icon: const Icon(Icons.replay),
                          color: Theme.of(context).cardColor,
                          iconSize: 30,
                        )
                      : const Text(""),
                ],
              ),
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pomodoros",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          "$totalPomodoros",
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        totalPomodoros > 0
                            ? IconButton(
                                onPressed: onResetPomodoroPressed,
                                icon: const Icon(Icons.replay),
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                iconSize: 20,
                              )
                            : const Text(""),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
