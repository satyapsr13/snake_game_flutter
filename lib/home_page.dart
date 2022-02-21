// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<Color> colors = [
  Colors.green,
  const Color.fromARGB(255, 250, 5, 5),
  const Color.fromARGB(255, 3, 203, 253),
  const Color.fromARGB(255, 252, 235, 3),
  const Color.fromARGB(255, 101, 5, 255),
];

List<int> snake = [20, 21, 22, 23, 24];
List<int> level = [700, 600, 500, 300];
int food = 250;
// Timer? timer;

class _HomePageState extends State<HomePage> {
  bool isStarted = false;
  bool isGameOver = false;
  bool isMovingUp = false;
  bool isMovingDown = false;
  bool isMovingRight = false;
  bool isMovingLeft = false;
  late final AudioCache _audioCache;

  int score = 0;
  void moveUp() {
    if (isStarted) {
      setState(() {
        isMovingUp = true;
        isMovingLeft = false;
        isMovingDown = false;
        isMovingRight = false;
      });
    } else {
      showdialogue();
    }
  }

  void moveDown() {
    if (isStarted) {
      setState(() {
        isMovingDown = true;
        isMovingLeft = false;
        isMovingUp = false;
        isMovingRight = false;
      });
    } else {
      showdialogue();
    }
  }

  void moveLeft() {
    if (isStarted) {
      setState(() {
        setState(() {
          isMovingDown = false;
          isMovingLeft = true;
          isMovingRight = false;
          isMovingUp = false;
        });
      });
    } else {
      showdialogue();
    }
  }

  void moveRight() {
    if (isStarted) {
      setState(() {
        isMovingDown = false;
        isMovingRight = true;
        isMovingLeft = false;
        isMovingUp = false;
      });
    } else {
      showdialogue();
    }
  }

  int gameLevel = level[2];
  int speed = 500;
  void startGame() {
    Navigator.pop(context);
    isStarted = true;
    isMovingDown = false;
    isMovingLeft = false;
    isMovingUp = false;
    isMovingRight = true;
    isGameOver = false;
    Timer.periodic(Duration(milliseconds: gameLevel), (timer) {
      setState(() {
        if (isGameOver) {
          timer.cancel();
        }
        snake.removeAt(0);

        if (isMovingRight) {
          if ((snake[3] + 1) % 20 == 0) {
            snake.insert(4, snake[3] - 19);
          } else {
            snake.insert(4, snake[3] + 1);
          }
        }
        if (isMovingLeft) {
          if ((snake[3] - 1) % 20 == 0) {
            snake.insert(4, snake[3] - 1);
            snake.remove(snake.first);
            snake.insert(4, snake[3] + 19);
          } else {
            snake.insert(4, snake[3] - 1);
          }
        }
        if (isMovingUp) {
          if (snake[3] - 20 >= 0) {
            snake.insert(4, snake[3] - 20);
          } else {
            snake.insert(4, snake[3] + (25 * 20));
          }
        }
        if (isMovingDown) {
          // if ((snake[3] + 20) % 20 == 0) {
          if (snake[3] + 20 < 500) {
            snake.insert(4, snake[3] + 20);
          } else {
            snake.insert(4, snake[3] - (25 * 20));
          }
        }

        if (snake.last == food) {
          // _audioCache.play('eat.wav');
          food = Random().nextInt(200);
          if (snake.contains(food)) {
            food += 10;
          }
          score += 10;
          // speed -= 80;
        }
      });
      if (snake.last == food) {
        score++;
        timer.cancel();
      }
    });
  }

  void endGame() {
    setState(() {
      Navigator.pop(context);
      isStarted = false;
      snake.clear();

      snake = [20, 21, 22, 23, 24];
      food = 40;

      food = Random().nextInt(480);
      if (snake.contains(food)) {
        food += 10;
      }
      isGameOver = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
      prefix: 'audio/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.LOOP),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        actions: [
          const Center(
            child: Text(
              '''StartGame 👉''',
              style: TextStyle(),
            ),
          ),
          TextButton(
            // onPressed: !isStarted ? startGame : endGame,
            onPressed: () {
              showModalBottomSheet<void>(
                elevation: 0,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Snake Game',
                            style: TextStyle(fontSize: 30),
                          ),
                          TextButton(
                            onPressed: !isStarted ? startGame : endGame,
                            child: !isStarted
                                ? const Icon(
                                    Icons.play_arrow,
                                    color: Colors.green,
                                    size: 40,
                                  )
                                : const Icon(Icons.pause,
                                    color: Colors.red, size: 40),
                          ),
                          const Text(
                            'Game Level',
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                splashColor: Colors.green,
                                onTap: () {
                                  setState(() {
                                    gameLevel = level[0];
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25 - (level[0] / 100),
                                  backgroundColor:
                                      const Color.fromARGB(255, 130, 76, 175),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gameLevel = level[1];
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 28 - (level[1] / 100),
                                  backgroundColor:
                                      const Color.fromARGB(255, 76, 168, 175),
                                  child: const Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gameLevel = level[2];
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30 - (level[2] / 100),
                                  backgroundColor:
                                      const Color.fromARGB(255, 84, 175, 76),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gameLevel = level[3];
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 35 - (level[0] / 100),
                                  backgroundColor:
                                      Color.fromARGB(255, 248, 6, 6),
                                  child: const Text(
                                    '4',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          const Center(
                            child: Text(
                              'By:- Satya Prakash',
                              style: TextStyle(),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: !isStarted
                ? const Text(
                    '▶',
                    style: TextStyle(),
                  )
                : const Icon(
                    Icons.pause,
                    color: Colors.white,
                  ),
          ),
          const Text(
            '''   ''',
            style: TextStyle(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  // borderRadius: BorderRadius()
                ),
                height: mediaquery.height * 0.6,
                width: mediaquery.width,
                child: GridView.builder(
                  itemCount: 500,
                  itemBuilder: (ctx, index) => Container(
                    decoration: BoxDecoration(
                      color: index == food
                          ? colors[index % colors.length]
                          : snake.contains(index)
                              ? const Color.fromARGB(251, 245, 241, 241)
                              : const Color.fromARGB(50, 255, 255, 255),
                      borderRadius: BorderRadius.circular(3),
                      // color: Color.fromARGB(6, 243, 8, 8),
                    ),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: (isMovingRight || isMovingLeft) ? moveUp : null,
                    child: const Text('☝')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed:
                              (isMovingDown || isMovingUp) ? moveLeft : null,
                          child: const Text('👈')),
                    ),
                    ElevatedButton(
                        onPressed:
                            (isMovingDown || isMovingUp) ? moveRight : null,
                        child: const Text('👉')),
                  ],
                ),
                ElevatedButton(
                    onPressed:
                        (isMovingRight || isMovingLeft) ? moveDown : null,
                    child: const Text('👇')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Text(
                  'MaxScore: 1000',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  AlertDialog showdialogue() {
    return AlertDialog(
      title: const Text('Are you mad ?'), // To display the title it is optional
      content: const Text(
          'Please start the game first.'), // Message which will be pop up on the screen
      // Action widget which will provide the user to acknowledge the choice
      actions: [
        TextButton(
          // textColor: Colors.black,
          onPressed: () {},
          child: const Text('OK'),
        ),
      ],
    );
  }
}
