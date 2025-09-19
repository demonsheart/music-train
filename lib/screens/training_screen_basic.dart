import 'package:flutter/material.dart';
import '../services/music_theory_logic.dart';
import '../widgets/answer_button.dart';
import '../widgets/feedback_overlay.dart';

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
  String _currentKey = 'C';
  bool _showFeedback = false;
  bool _isCorrect = false;
  int _score = 0;
  int _streak = 0;
  bool _showKeySelector = true;

  @override
  void initState() {
    super.initState();
    // Don't generate question until user selects a key
  }

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
      _currentNote = MusicTheoryLogic.getNoteForDegree(
        _currentKey,
        _isMajor,
        _currentDegree
      );
    });
  }

  void selectKey(String key) {
    setState(() {
      _currentKey = key;
      _showKeySelector = false;
      generateNewQuestion();
    });
  }

  void handleAnswer(dynamic answer) {
    final isCorrect = MusicTheoryLogic.validateAnswer(
      _currentKey,
      _isMajor,
      _isForwardMode,
      _currentDegree,
      _currentNote,
      answer,
    );

    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _score += 10;
        _streak += 1;
      } else {
        _streak = 0;
      }
    });
  }

  void hideFeedback() {
    setState(() {
      _showFeedback = false;
    });
    generateNewQuestion();
  }

  void showKeySelector() {
    setState(() {
      _showKeySelector = true;
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
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('$_score', style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Icon(Icons.local_fire_department, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text('$_streak', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
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
          child: Stack(
            children: [
              Column(
                children: [
                  if (_showKeySelector) ...[
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
                            '选择训练调性',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          _buildKeySelectorGrid(),
                        ],
                      ),
                    ),
                  ] else ...[
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_currentKey ${_isMajor ? '大调' : '小调'}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.grey),
                                onPressed: showKeySelector,
                                tooltip: '更换调性',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (!_showKeySelector) ...[
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
                  ],
                  if (!_showKeySelector) ...[
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildAnswerGrid(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
              if (_showFeedback)
                Center(
                  child: FeedbackOverlay(
                    isCorrect: _isCorrect,
                    onComplete: hideFeedback,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeySelectorGrid() {
    final keys = MusicTheoryLogic.getAvailableNotes();
    return Container(
      height: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return AnswerButton(
            text: keys[index],
            onPressed: () => selectKey(keys[index]),
            backgroundColor: Colors.green.shade100,
            textColor: Colors.green.shade900,
          );
        },
      ),
    );
  }

  Widget _buildAnswerGrid() {
    if (_isForwardMode) {
      // 正向模式：选择音名
      final notes = MusicTheoryLogic.getAvailableNotes();
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return AnswerButton(
            text: notes[index],
            onPressed: () => handleAnswer(notes[index]),
            backgroundColor: Colors.blue.shade100,
            textColor: Colors.blue.shade900,
          );
        },
      );
    } else {
      // 反向模式：选择级数
      final degrees = MusicTheoryLogic.getAvailableDegrees();
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return AnswerButton(
            text: degrees[index].toString(),
            onPressed: () => handleAnswer(degrees[index]),
            backgroundColor: Colors.purple.shade100,
            textColor: Colors.purple.shade900,
          );
        },
      );
    }
  }
}