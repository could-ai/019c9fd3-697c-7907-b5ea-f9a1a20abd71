class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'questions': questions.map((q) => q.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'],
    title: json['title'],
    questions: (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    text: json['text'],
    options: List<String>.from(json['options']),
    correctAnswerIndex: json['correctAnswerIndex'],
  );
}

class QuizResult {
  final String quizId;
  final String studentId;
  final String studentName;
  final int score;
  final int totalQuestions;
  final Map<String, int> answers; // questionId -> selectedAnswerIndex
  final DateTime submittedAt;

  QuizResult({
    required this.quizId,
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.totalQuestions,
    required this.answers,
    required this.submittedAt,
  });

  double get percentage => (score / totalQuestions) * 100;

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'studentId': studentId,
    'studentName': studentName,
    'score': score,
    'totalQuestions': totalQuestions,
    'answers': answers,
    'submittedAt': submittedAt.toIso8601String(),
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    quizId: json['quizId'],
    studentId: json['studentId'],
    studentName: json['studentName'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    answers: Map<String, int>.from(json['answers']),
    submittedAt: DateTime.parse(json['submittedAt']),
  );
}