import 'package:flutter/material.dart';

class TrainingScreenBasic extends StatefulWidget {
  const TrainingScreenBasic({super.key});

  @override
  State<TrainingScreenBasic> createState() => _TrainingScreenBasicState();
}

class _TrainingScreenBasicState extends State<TrainingScreenBasic> {
  bool _isMajor = true;
  bool _isForwardMode = true;
  int _currentDegree = 1;
  String _currentNote = 'C';

  void toggleKeyMode() {
    setState(() {
      _isMajor = !_isMajor;
      generateNewQuestion();
    });
  }

  void toggleTrainingMode() {
    setState(() {
      _isForwardMode = !_isForwardMode;
      generateNewQuestion();
    });
  }

  void generateNewQuestion() {
    setState(() {
      _currentDegree = (DateTime.now().second % 7) + 1;
      final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
      _currentNote = notes[DateTime.now().millisecond % notes.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐训练'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '当前调性',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_currentNote ${_isMajor ? '大调' : '小调'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_isForwardMode) ...[
                      const Text(
                        '级数',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_currentDegree',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '对应的音名是？',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ] else ...[
                      const Text(
                        '音名',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentNote,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '对应的级数是？',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: toggleKeyMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMajor ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isMajor ? '大调' : '小调'),
                  ),
                  ElevatedButton(
                    onPressed: toggleTrainingMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isForwardMode ? Colors.blue : Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isForwardMode ? '正向练习' : '反向练习'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateNewQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('生成新题目'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}