import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color c = Colors.green;
  int count = 1;
  List<Color> cl = [Colors.green];
  ConfettiController _controllerwin = ConfettiController();
  int number = 1;
  int sumOfDigits(int number) {
    int sum =
        number.toString().split('').map(int.parse).reduce((a, b) => a + b);
    return sum % 10; // Return the rightmost digit of the sum
  }

  Future<void> getRandomColor() async {
    OverlayLoadingProgress.start(context, barrierDismissible: false);
    await Future.delayed(const Duration(milliseconds: 1000));

    Random random = Random();
    var redAndGreenColors = [
      Colors.red,
      Colors.green,
    ];
    var t = 10 + random.nextInt(90);
    t = sumOfDigits(t);
    if ((t % 2) == 0) {
      setState(() {
        c = Colors.red;
        cl.add(c);
        number = t;
      });
    } else {
      setState(() {
        c = Colors.green;
        cl.add(c);
        number = t;
      });
    }

    OverlayLoadingProgress.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '    ColPredict',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              cl.clear();
              await getRandomColor();
              setState(() {
                count = 1;
              });
            },
            icon: Icon(Icons.refresh),
            padding: EdgeInsets.only(right: 20),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.width / 1.8,
                      decoration: BoxDecoration(
                          color: c, borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Go With ${c == Colors.green ? "Green" : "Red"}',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                            itemCount: cl.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: cl[i],
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          '$count X',
                          style: TextStyle(
                              fontSize: '$count X'.length > 5 ? 80 : 120,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Action to perform when Win button is pressed
                            print('Loss button pressed');
                            await getRandomColor();
                            setState(() {
                              count = count * 3;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .grey.shade100, // Set button color to green
                            onPrimary: Colors.black,
                            // Set text color to white
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16), // Set button padding
                          ),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(child: Text('Loss'))),
                        ),
                        SizedBox(width: 16), // Add some spacing between buttons
                        ElevatedButton(
                          onPressed: () async {
                            // Action to perform when Loss button is pressed
                            print('Loss button pressed');
                            _controllerwin.play();
                            cl.clear();
                            await getRandomColor();
                            _controllerwin.stop();
                            setState(() {
                              count = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black, // Set button color to red
                            onPrimary: Colors.white, // Set text color to white
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16), // Set button padding
                          ),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(child: Text('Win'))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _controllerwin,
                    shouldLoop: true,
                    blastDirection: 3.14 / 2,
                    minimumSize: Size(1, 10),
                    maximumSize: Size(10, 20),
                    colors: [
                      Colors.green,
                      Colors.red,
                      Colors.blue,
                      Colors.yellow,
                      Colors.purple,
                      Colors.white,
                      Colors.orange,
                      Colors.indigo,
                      Colors.pink,
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
