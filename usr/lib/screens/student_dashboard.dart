import 'package:flutter/material.dart';
import '../models/quiz.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final String studentId = 'student1'; // Mock
  final String studentName = 'Şagird 1'; // Mock
  final List<Quiz> _availableQuizzes = []; // Müəllimin yaratdığı testlər
  final Map<String, QuizResult> _myResults = {};

  @override
  void initState() {
    super.initState();
    // Mock test əlavə et
    _availableQuizzes.add(Quiz(
      id: '1',
      title: 'Riyaziyyat Testi',
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
    ));
  }

  void _takeQuiz(Quiz quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTakingScreen(
          quiz: quiz,
          studentId: studentId,
          studentName: studentName,
          onComplete: (result) {
            setState(() {
              _myResults[quiz.id] = result;
              // Burada real-time üçün backendə göndəriləcək
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şagird Paneli'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Mövcud Testlər:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _availableQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = _availableQuizzes[index];
                final hasResult = _myResults.containsKey(quiz.id);
                return ListTile(
                  title: Text(quiz.title),
                  subtitle: hasResult ? Text('Bal: ${_myResults[quiz.id]!.score}/${_myResults[quiz.id]!.totalQuestions}') : const Text('Hələ verilməyib'),
                  trailing: ElevatedButton(
                    onPressed: hasResult ? null : () => _takeQuiz(quiz),
                    child: Text(hasResult ? 'Tamamlandı' : 'Başla'),
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

class QuizTakingScreen extends StatefulWidget {
  final Quiz quiz;
  final String studentId;
  final String studentName;
  final Function(QuizResult) onComplete;

  const QuizTakingScreen({
    super.key,
    required this.quiz,
    required this.studentId,
    required this.studentName,
    required this.onComplete,
  });

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  int currentQuestionIndex = 0;
  final Map<String, int> _answers = {};

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[widget.quiz.questions[currentQuestionIndex].id] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    int score = 0;
    for (final question in widget.quiz.questions) {
      if (_answers[question.id] == question.correctAnswerIndex) {
        score++;
      }
    }
    final result = QuizResult(
      quizId: widget.quiz.id,
      studentId: widget.studentId,
      studentName: widget.studentName,
      score: score,
      totalQuestions: widget.quiz.questions.length,
      answers: _answers,
      submittedAt: DateTime.now(),
    );
    widget.onComplete(result);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test tamamlandı! Bal: $score/${widget.quiz.questions.length}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sual ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(question.text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return RadioListTile<int>(
                title: Text(option),
                value: index,
                groupValue: _answers[question.id],
                onChanged: (value) => _selectAnswer(value!),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _answers.containsKey(question.id) ? _nextQuestion : null,
              child: Text(currentQuestionIndex < widget.quiz.questions.length - 1 ? 'Növbəti' : 'Təqdim Et'),
            ),
          ],
        ),
      ),
    );
  }
}