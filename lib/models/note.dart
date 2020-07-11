class Note {
  String id;
  bool finished;
  String initialDescription;
  String initialImage;
  String user;
  String finalDescription;
  String finalImage;
  String startedAt;
  String stopedAt;

  Note(
      {this.id,
      this.finished,
      this.initialDescription,
      this.initialImage,
      this.user,
      this.finalDescription,
      this.finalImage,
      this.startedAt,
      this.stopedAt});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['_id'],
        finished: json['finished'],
        initialDescription: json['initialDescription'],
        initialImage: json['initialImage'],
        user: json['user'],
        finalDescription: json['finalDescription'],
        finalImage: json['finalImage'],
        startedAt: json['startedAt'],
        stopedAt: json['stopedAt']);
  }
}
