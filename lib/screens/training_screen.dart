import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/music_theory_service.dart';
import '../services/timer_service.dart';
import '../services/reward_service.dart';
import '../widgets/note_button.dart';
import '../widgets/degree_button.dart';
import '../widgets/stats_display.dart';
import '../widgets/feedback_animation.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  bool _showFeedback = false;
  bool _isCorrect = false;

  void _handleAnswer(MusicTheoryService musicService, RewardService rewardService, dynamic answer) {
    final isCorrect = musicService.checkAnswer(answer);

    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;
    });

    rewardService.updateScore(isCorrect ? 10 : 0, musicService.streak);
  }

  void _hideFeedback() {
    setState(() {
      _showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<MusicTheoryService, TimerService, RewardService>(
      builder: (context, musicService, timerService, rewardService, child) {
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
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => musicService.generateNewQuestion(),
              ),
              IconButton(
                icon: Icon(timerService.isRunning ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (timerService.isRunning) {
                    timerService.stop();
                  } else {
                    timerService.start();
                  }
                },
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
                      const StatsDisplay(),
                      const SizedBox(height: 20),
                      _buildControls(context, musicService),
                      const SizedBox(height: 30),
                      _buildQuestionDisplay(context, musicService),
                      const SizedBox(height: 30),
                      _buildAnswerOptions(context, musicService, rewardService),
                      const SizedBox(height: 20),
                      _buildFeedback(context, musicService),
                    ],
                  ),
                  if (_showFeedback)
                    Center(
                      child: FeedbackAnimation(
                        isCorrect: _isCorrect,
                        onComplete: _hideFeedback,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls(BuildContext context, MusicTheoryService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => service.toggleKeyMode(),
            style: ElevatedButton.styleFrom(
              backgroundColor: service.isMajor ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(service.isMajor ? '大调' : '小调'),
          ),
          ElevatedButton(
            onPressed: () => service.toggleTrainingMode(),
            style: ElevatedButton.styleFrom(
              backgroundColor: service.isForwardMode ? Colors.blue : Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Text(service.isForwardMode ? '正向练习' : '反向练习'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionDisplay(BuildContext context, MusicTheoryService service) {
    if (service.currentKey == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            '当前调性',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            service.currentKey!.displayName,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          if (service.isForwardMode)
            Column(
              children: [
                Text(
                  '级数',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service.currentScaleDegree?.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '对应的音名是？',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  '音名',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service.currentNote?.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '对应的级数是？',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, MusicTheoryService service, RewardService rewardService) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: service.isForwardMode
              ? service.getAvailableNotes().length
              : service.getAvailableScaleDegrees().length,
          itemBuilder: (context, index) {
            if (service.isForwardMode) {
              final note = service.getAvailableNotes()[index];
              return NoteButton(
                note: note,
                onPressed: () => _handleAnswer(service, rewardService, note),
              );
            } else {
              final degree = service.getAvailableScaleDegrees()[index];
              return DegreeButton(
                degree: degree,
                onPressed: () => _handleAnswer(service, rewardService, degree),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFeedback(BuildContext context, MusicTheoryService service) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (service.streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '连续答对 ${service.streak} 题！',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}