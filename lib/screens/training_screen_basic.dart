import 'package:flutter/material.dart';
import 'dart:async';
import '../services/music_theory_logic.dart';
import '../widgets/answer_button.dart';

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
  bool _isCorrect = false;
  int _score = 0;
  int _streak = 0;
  bool _showKeySelector = true;
  bool _showDurationSelector = true;
  int _selectedDuration = 5; // 默认5分钟
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalAnswered = 0;
  int _correctAnswered = 0;
  DateTime? _questionStartTime;
  double _averageResponseTime = 0;
  List<double> _responseTimes = [];
  bool _showingAnswer = false;
  String? _correctAnswer;

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
      _questionStartTime = DateTime.now();
    });
  }

  void selectKey(String key) {
    setState(() {
      _currentKey = key;
      _showKeySelector = false;
      generateNewQuestion();
      startTimer(); // 开始计时
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

    // 计算答题时间
    final responseTime = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000.0
        : 0.0;

    // 获取正确答案
    String? correctAnswer;
    if (_isForwardMode) {
      correctAnswer = MusicTheoryLogic.getNoteForDegree(_currentKey, _isMajor, _currentDegree);
    } else {
      correctAnswer = MusicTheoryLogic.getDegreeForNote(_currentKey, _isMajor, _currentNote).toString();
    }

    setState(() {
      _totalAnswered++;
      _responseTimes.add(responseTime);

      // 计算平均答题时间
      if (_responseTimes.isNotEmpty) {
        _averageResponseTime = _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;
      }

      _isCorrect = isCorrect;
      _showingAnswer = true;
      _correctAnswer = correctAnswer;

      if (isCorrect) {
        _score += 10;
        _streak += 1;
        _correctAnswered++;
      } else {
        _streak = 0;
      }

      // 延迟后生成下一题
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _showingAnswer = false;
            _correctAnswer = null;
          });
          generateNewQuestion();
        }
      });
    });
  }

  
  void showKeySelector() {
    setState(() {
      _showKeySelector = true;
    });
  }

  void selectDuration(int minutes) {
    setState(() {
      _selectedDuration = minutes;
      _showDurationSelector = false;
    });
  }

  void startTimer() {
    _remainingSeconds = _selectedDuration * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _showTrainingComplete();
        }
      });
    });
  }

  void _showTrainingComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('训练完成！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('训练时长: $_selectedDuration 分钟'),
            Text('总答题数: $_totalAnswered'),
            Text('正确答题数: $_correctAnswered'),
            Text('正确率: ${_totalAnswered > 0 ? (_correctAnswered / _totalAnswered * 100).toStringAsFixed(1) : 0}%'),
            Text('平均答题速度: ${_averageResponseTime.toStringAsFixed(2)} 秒'),
            Text('最终得分: $_score'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('完成'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

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
          if (!_showKeySelector && !_showDurationSelector) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.green, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
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
                  if (_showDurationSelector) ...[
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
                            '选择训练时长',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          _buildDurationSelectorGrid(),
                        ],
                      ),
                    ),
                  ] else if (_showKeySelector) ...[
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
                  if (!_showKeySelector && !_showDurationSelector) ...[
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 15),
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
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: isSmallScreen ? 3 : 5),
                            Text(
                              '$_currentDegree',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 28 : 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 3 : 5),
                            const Text(
                              '对应的音名是？',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ] else ...[
                            const Text(
                              '音名',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: isSmallScreen ? 3 : 5),
                            Text(
                              _currentNote,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 28 : 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 3 : 5),
                            const Text(
                              '对应的级数是？',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (!_showKeySelector && !_showDurationSelector) ...[
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 10),
                    if (_totalAnswered > 0) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text('答题速度', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    Text(
                                      '${_averageResponseTime.toStringAsFixed(1)}s',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('正确率', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    Text(
                                      '${_totalAnswered > 0 ? (_correctAnswered / _totalAnswered * 100).toStringAsFixed(0) : 0}%',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('总题数', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    Text(
                                      '$_totalAnswered',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // 答题速度趋势指示器
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: _averageResponseTime > 3 ? 50 : (_averageResponseTime / 3 * 50),
                                    decoration: BoxDecoration(
                                      color: _averageResponseTime > 3 ? Colors.red : Colors.green,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _averageResponseTime > 3 ? '速度较慢，加油！' : '速度很好！',
                              style: TextStyle(
                                fontSize: 10,
                                color: _averageResponseTime > 3 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 20),
                        child: _buildAnswerGrid(),
                      ),
                    ),
                  ],
                  SizedBox(height: isSmallScreen ? 10 : 20),
                ],
              ),
                          ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelectorGrid() {
    final durations = [5, 10, 20, 30];
    return Container(
      height: 150,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5,
        ),
        itemCount: durations.length,
        itemBuilder: (context, index) {
          return AnswerButton(
            text: '${durations[index]} 分钟',
            onPressed: () => selectDuration(durations[index]),
            backgroundColor: Colors.orange.shade100,
            textColor: Colors.orange.shade900,
          );
        },
      ),
    );
  }

  Widget _buildKeySelectorGrid() {
    final keys = MusicTheoryLogic.getAvailableNotes();
    return Container(
      height: 250,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
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
    final isSmallScreen = MediaQuery.of(context).size.height < 700;

    if (_isForwardMode) {
      // 正向模式：选择音名
      final notes = MusicTheoryLogic.getAvailableNotes();
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: isSmallScreen ? 6 : 8,
          mainAxisSpacing: isSmallScreen ? 6 : 8,
          childAspectRatio: isSmallScreen ? 0.9 : 1.0,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          ButtonState state = ButtonState.normal;

          if (_showingAnswer) {
            if (_isCorrect && note == _currentNote) {
              state = ButtonState.correct;
            } else if (!_isCorrect && note == _correctAnswer) {
              state = ButtonState.correctAnswer;
            } else if (!_isCorrect && note == _currentNote) {
              state = ButtonState.incorrect;
            }
          }

          return AnswerButton(
            text: note,
            onPressed: _showingAnswer ? null : () => handleAnswer(note),
            backgroundColor: Colors.blue.shade100,
            textColor: Colors.blue.shade900,
            state: state,
          );
        },
      );
    } else {
      // 反向模式：选择级数
      final degrees = MusicTheoryLogic.getAvailableDegrees();
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: isSmallScreen ? 6 : 8,
          mainAxisSpacing: isSmallScreen ? 6 : 8,
          childAspectRatio: isSmallScreen ? 0.9 : 1.0,
        ),
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          final degree = degrees[index];
          ButtonState state = ButtonState.normal;

          if (_showingAnswer) {
            if (_isCorrect && degree.toString() == _currentDegree.toString()) {
              state = ButtonState.correct;
            } else if (!_isCorrect && degree.toString() == _correctAnswer) {
              state = ButtonState.correctAnswer;
            } else if (!_isCorrect && degree.toString() == _currentDegree.toString()) {
              state = ButtonState.incorrect;
            }
          }

          return AnswerButton(
            text: degree.toString(),
            onPressed: _showingAnswer ? null : () => handleAnswer(degree),
            backgroundColor: Colors.purple.shade100,
            textColor: Colors.purple.shade900,
            state: state,
          );
        },
      );
    }
  }
}