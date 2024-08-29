
import 'package:job_seeker/models/quiz.dart';

class TestQ {
  String id;
  String idRecruter;
  String idCandidat;
  String idQuiz;
  Quiz quiz;
  String date;
  String status;
  double score;

  TestQ({
    required this.id,
    required this.idRecruter,
    required this.idCandidat,
    required this.idQuiz,
    required this.quiz,
    required this.date,
    required this.score,
    required this.status,
  });

  factory TestQ.fromJson(Map<String, dynamic> json, Quiz quiz) {
    return TestQ(
      id: json['_id'],
      idRecruter: json['idRecruter'],
      idCandidat: json['idCandidat'],
      idQuiz: json['idQuiz'],
      quiz: quiz,
      date: json['date'],
      score: (json['score'] is int)
          ? (json['score'] as int).toDouble()
          : json['score'] as double,
      status: json['status'],
    );
  }
}
