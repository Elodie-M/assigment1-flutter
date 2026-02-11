import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Random Number Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final Random _rng = Random();

  int? _currentNumber;

  final Map<int, int> _counts = {
    for (int i = 1; i <= 9; i++) i: 0,
  };
  

  void _generate() {
    setState(() {
      final n = _rng.nextInt(9) + 1;

      _currentNumber = n;

      _counts[n] = (_counts[n] ?? 0) + 1;
    });
}
void _resetAll() {
  setState(() {
    for (int i = 1; i <= 9; i++) {
      _counts[i] = 0;
    }
    _currentNumber = null;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  _currentNumber == null ? "" : '$_currentNumber',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generate,
                  child: const Text("Generate"),
                ),
              ),
              const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySecondPage(
                            title: "Second Page",
                            counts: _counts,
                            onReset: _resetAll,
                          ),
                        ),
                      );
                    },
                    child: const Text("View Statistics"),
                  ),
                ),
            ],
          )
          
        ),
      ],
    ),
    );
  }
}

class MySecondPage extends StatefulWidget {
  const MySecondPage({
    super.key, 
    required this.title, 
    required this.counts,
    required this.onReset,
    });

  final String title;
  final Map<int, int> counts;
  final VoidCallback onReset;

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}
class _MySecondPageState extends State<MySecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Statistics"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index) {
                final number = index + 1;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Number $number"),
                      Text("${widget.counts[number]} times"),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onReset();
                      setState(() {});
                    },
                    child: const Text("Reset"),
                  ),
                ),
              const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to Home"),
                    ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
  }

        