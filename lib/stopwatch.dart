import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatefulWidget {
  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  List<Duration> lapTimes = [];
  bool _isRunning = false;
  bool _buttonsVisible = false; // Initially, buttons are hidden

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 10), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_isRunning) {
      setState(() {});
    }
  }

  void _startStop() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
      _isRunning = !_isRunning;
      _buttonsVisible = true; // Show buttons when starting or stopping
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.reset();
      lapTimes.clear();
      _buttonsVisible = false; // Hide buttons after resetting
    });
  }


  void _lap() {
    setState(() {
      if (_isRunning) {
        lapTimes.add(_stopwatch.elapsed);
      }
    });
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$hours:$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.teal,
          title: Text('Stopwatch', style: TextStyle(letterSpacing: 1.0),),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: !_buttonsVisible, // Initially, show only IconButton and time
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 200.0), // Adjust the value as needed
                          child: Text(
                            _formatTime(_stopwatch.elapsed),
                            style: TextStyle(fontSize: 55.0, color: Colors.teal.shade900, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.teal.withOpacity(0.1)
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isRunning ? Icons.pause : Icons.play_arrow,
                              size: 40, color: Colors.teal.shade900,
                            ),
                            onPressed: _startStop,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: _buttonsVisible, // Show buttons when _buttonsVisible is true
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 200.0),
                          child: Text(
                            _formatTime(_stopwatch.elapsed),
                            style: TextStyle(fontSize: 55.0, color: Colors.teal.shade900, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.teal.withOpacity(0.1)
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isRunning ? Icons.pause : Icons.play_arrow,
                                  size: 36, color: Colors.teal.shade900,
                                ),
                                onPressed: _startStop,
                              ),
                            ),
                            SizedBox(width: 50),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.teal.withOpacity(0.1)
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isRunning ? Icons.add : Icons.stop,
                                  size: 36, color: Colors.teal.shade900,
                                ),
                                onPressed: _isRunning ? _lap : _reset,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        if (lapTimes.isNotEmpty)
                          Column(
                            children: lapTimes
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Text(
                                'Lap ${entry.key + 1}:   ${_formatTime(entry.value)}',
                                style: TextStyle(fontSize: 18.0, letterSpacing: 2.0, color: Colors.blueGrey.shade400),
                              ),
                            )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
