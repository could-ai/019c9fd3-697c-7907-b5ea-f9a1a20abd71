import 'package:flutter/material.dart';
import '../models/quiz.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final List<Quiz> _quizzes = [];
  final List<QuizResult> _results = [];

  void _createQuiz() {
    // Mock quiz yaratmaq
    final quiz = Quiz(
      id: DateTime.now().toString(),
      title: 'Yeni Test',
      questions: [
        Question(
          id: '1',
          text: '2 + 2 nə qədərdir?',
          options: ['3', '4', '5', '6'],
          correctAnswerIndex: 1,
        ),
        Question(
          id: '2',
          text: 'Azərbaycanın paytaxtı hansıdır?',
          options: ['Bakı', 'İstanbul', 'Tbilisi', 'Yerevan'],
          correctAnswerIndex: 0,
        ),
      ],
      createdAt: DateTime.now(),
    );
    setState(() {
      _quizzes.add(quiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müəllim Paneli'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _createQuiz,
            child: const Text('Yeni Test Yarat'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _quizzes.length,
              itemBuilder: (context, index) {
                final quiz = _quizzes[index];
                return ListTile(
                  title: Text(quiz.title),
                  subtitle: Text('${quiz.questions.length} sual'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Nəticələri göstər
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('${quiz.title} Nəticələri'),
                          content: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: _results.where((r) => r.quizId == quiz.id).length,
                              itemBuilder: (context, i) {
                                final result = _results.where((r) => r.quizId == quiz.id).toList()[i];
                                return ListTile(
                                  title: Text(result.studentName),
                                  subtitle: Text('Bal: ${result.score}/${result.totalQuestions} (${result.percentage.toStringAsFixed(1)}%)'),
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Bağla'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Nəticələr'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}