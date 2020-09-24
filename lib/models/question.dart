
class Question {
  int id;
  String qn;

  Question({this.qn});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      qn: map['qn'],
    );
  }

  static Map<String, dynamic> toMap(Question question) {
    final Map<String, dynamic> data = <String, dynamic>{
      'qn': question.qn,
    };

    return data;
  }
}
