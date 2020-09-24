class Comment {
  int id;
  String fullName;
  String email;
  String message;

  Comment({this.fullName, this.email, this.message});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
        fullName: map['full_name'],
        email: map['email'],
        message: map['message']);
  }

  static Map<String, dynamic> toMap(Comment comment) {
    final Map<String, dynamic> data = <String, dynamic>{
      'full_name': comment.fullName,
      'email': comment.email,
      'message': comment.message
    };

    return data;
  }
}
