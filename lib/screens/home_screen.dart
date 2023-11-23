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
  bool isAudioLoaded = false;
  String title = "Pomodoro Time";
  // static int defaultSeconds = 3; // for Debugging
  static int defaultSeconds = 1500; // for Debugging
  int totalSeconds = defaultSeconds;
  int totalPomodoros = 0;
  bool isTimerRunning = false;
  bool isBreakTime = false;

  late Timer timer;

  int minToSec(int minute) {
    return minute * 60;
  }

  onTick(Timer timer) {
    if (totalSeconds == 0) {
      timer.cancel();
      setState(() {
        if (isBreakTime) {
          isTimerRunning = false;
          isBreakTime = false;
          title = "Pomodoro Time";
          totalSeconds = defaultSeconds;
          player.resume();
        } else {
          totalPomodoros++;
          isTimerRunning = false;
          isBreakTime = true;
          title = "Break Time";
          // totalSeconds = 3; // for debugging
          totalSeconds = minToSec(5);
          player.resume();
        }
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

  onSkipPressed() {
    timer.cancel();
    setState(() {
      totalSeconds = defaultSeconds;
      isBreakTime = false;
      isTimerRunning = false;
    });
  }

  onFifteenPressed() {
    setState(() {
      totalSeconds = minToSec(15);
      defaultSeconds = totalSeconds;
    });
  }

  onTwentyPressed() {
    setState(() {
      totalSeconds = minToSec(20);
      defaultSeconds = totalSeconds;
    });
  }

  onTwentyFivePressed() {
    setState(() {
      totalSeconds = minToSec(25);
      defaultSeconds = totalSeconds;
    });
  }

  onThirtyPressed() {
    setState(() {
      totalSeconds = minToSec(30);
      defaultSeconds = totalSeconds;
    });
  }

  onThirtyFivePressed() {
    setState(() {
      totalSeconds = minToSec(35);
      defaultSeconds = totalSeconds;
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
      appBar: AppBar(
        title: Text(title),
      ),
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
              flex: 1,
              child: Center(
                child: isBreakTime
                    ? Text(
                        "Take a Break!",
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 36,
                        ),
                      )
                    : GridView.count(
                        padding: const EdgeInsets.all(20),
                        childAspectRatio: (1 / .4),
                        crossAxisCount: 3,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              onPressed: onFifteenPressed,
                              icon: const Icon(Icons.timer),
                              label: const Text("15min"),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              onPressed: onTwentyPressed,
                              icon: const Icon(Icons.timer),
                              label: const Text("20min"),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              onPressed: onTwentyFivePressed,
                              icon: const Icon(Icons.timer),
                              label: const Text("25min"),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              onPressed: onThirtyPressed,
                              icon: const Icon(Icons.timer),
                              label: const Text("30min"),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              onPressed: onThirtyFivePressed,
                              icon: const Icon(Icons.timer),
                              label: const Text("35min"),
                            ),
                          ),
                        ],
                      ),
              )),
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
                  (totalSeconds < defaultSeconds && !isBreakTime)
                      ? IconButton(
                          onPressed: onResetPressed,
                          icon: const Icon(Icons.replay),
                          color: Theme.of(context).cardColor,
                          iconSize: 30,
                        )
                      : const SizedBox(),
                  isBreakTime
                      ? IconButton(
                          onPressed: onSkipPressed,
                          icon: const Icon(Icons.fast_forward),
                          color: Theme.of(context).cardColor,
                          iconSize: 30,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pomodoros",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                    ),
                                  ),
                                  Text(
                                    "${totalPomodoros % 4}/4",
                                    style: TextStyle(
                                      fontSize: 58,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rounds",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                    ),
                                  ),
                                  Text(
                                    "${(totalPomodoros / 4).floor()}",
                                    style: TextStyle(
                                      fontSize: 58,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                        totalPomodoros > 0
                            ? IconButton(
                                onPressed: onResetPomodoroPressed,
                                icon: const Icon(
                                  Icons.replay,
                                  size: 25,
                                ),
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                iconSize: 15,
                              )
                            : const SizedBox(),
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
