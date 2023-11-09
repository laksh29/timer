import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer/buttoms_widget.dart';

import 'constants.dart';
import 'indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int timeLimit = 30;
  int counter = timeLimit;
  Timer? timer;
  bool isMusicOn = true;
  int index = 0;
  List<String> title = [
    "Nom nom :)",
    "Break Time",
    "Finish your meal",
  ];
  List<String> subTitle = [
    "You have 10 minutes to eat before the pause. Focus on eating slowly",
    "Take a five-minute break to check in on your level of fullnes",
    "You can eat until you feel full",
  ];
  final audioPath = "countdown_tick.mp3";

  final AudioPlayer player = AudioPlayer();

  void startTime({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (counter > 0) {
        setState(() => counter--);
      } else if (counter == 0) {
        cancelTimer();
        setState(() {
          index++;
          if (index > 2) {
            index = 0;
          }
        });
      } else {
        cancelTimer(reset: false);
      }
    });
  }

  void cancelTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      timer!.cancel();
    });
  }

  void resetTimer() {
    setState(() {
      counter = timeLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTimerOn = timer == null ? false : timer!.isActive;

    final bool isTimerComplete = counter == timeLimit || counter == 0;

    if (counter < 5 && counter > 0) {
      player.play(AssetSource(audioPath), volume: isMusicOn ? 1.0 : 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mindful Meal Timer"),
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            // circle indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Indicator(
                  index: index,
                  activeIndex: 0,
                  radius: 8,
                ),
                buildWidth(5),
                Indicator(
                  index: index,
                  activeIndex: 1,
                  radius: 10,
                ),
                buildWidth(5),
                Indicator(
                  index: index,
                  activeIndex: 2,
                  radius: 8,
                ),
              ],
            ),
            buildHeight(20),
            // title
            Text(
              title[index],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            buildHeight(10),
            // sub title
            Text(
              subTitle[index],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
            buildHeight(50),
            // timer counter
            SizedBox(
              height: 300,
              width: 300,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    radius: 200,
                  ),
                  const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 120,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Expanded(
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          color: Colors.green,
                          value: counter / timeLimit,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "00 : $counter",
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        ),
                        buildHeight(5.0),
                        const Text(
                          "minutes remaining",
                          style: TextStyle(color: Colors.black26),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            buildHeight(50),
            // music toggle
            CupertinoSwitch(
                value: isMusicOn,
                onChanged: (t) => setState(() {
                      isMusicOn = t;
                    })),
            buildHeight(5.0),
            // sound on
            Text(isMusicOn ? "Sound On" : "Sound Off"),
            buildHeight(5.0),
            // primary buttons
            isTimerOn || !isTimerComplete
                ? ButtonWidget(
                    text: isTimerOn ? "PAUSE" : 'RESUME',
                    onClicked: () => isTimerOn
                        ? cancelTimer(reset: false)
                        : startTime(reset: false),
                  )
                : ButtonWidget(
                    text: "PLAY",
                    onClicked: () {
                      startTime();
                    },
                  ),
            buildHeight(20),
            // secondary button
            const ButtonWidget(
              text: "LET'S STOP I;M FULL NOW",
              secondary: true,
            )
          ],
        ),
      ),
    );
  }
}
