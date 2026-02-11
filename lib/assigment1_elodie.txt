import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

const Color kAppBarColor = Color(0xFF147CD3);
const Color kBodyColor = Color(0xFF2196F3);
const Color kButtonColor = Color(0xFF147CD3);
const Color kTextColor = Colors.white;

final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kButtonColor,
  foregroundColor: kTextColor,
  minimumSize: const Size(double.infinity, 48),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2),
  ),
  elevation: 4,
  textStyle: const TextStyle(fontSize: 16),
);

const TextStyle kNumberTextStyle = TextStyle(
  fontSize: 64,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

const TextStyle kStatsRowTextStyle = TextStyle(
  fontSize: 16,
  color: kTextColor,
);

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
        useMaterial3: true,
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  final Random _rng = Random();

  int? _currentNumber;

  late final AnimationController _controller;
  Timer? _timer;

  final Map<int, int> _counts = {
    for (int i = 1; i <= 9; i++) i: 0,
  };
  

  void _generate() {
    final n = _rng.nextInt(9) + 1;

    setState(() {
      _currentNumber = n;
      _counts[n] = (_counts[n] ?? 0) + 1;
    });

    _controller.forward(from: 0); 

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _controller.reset();
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
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
}

@override
void dispose() {
  _timer?.cancel();
  _controller.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        foregroundColor: kTextColor,
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * pi, 
                      child: child,
                    );
                  },
                  child: Text(
                    _currentNumber == null ? "" : '$_currentNumber',
                    style: kNumberTextStyle
                  ),
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
                  style: _elevatedButtonStyle,
                  onPressed: _generate,
                  child: const Text("Generate"),
                ),
              ),
              const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: _elevatedButtonStyle,
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
      backgroundColor: kBodyColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        foregroundColor: kTextColor,
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
                      Text("Number $number",
                        style: kStatsRowTextStyle,),
                      Text("${widget.counts[number]} times",
                        style: kStatsRowTextStyle,),
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
                    style: _elevatedButtonStyle,
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
                    style: _elevatedButtonStyle,
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
 