class Suggestion {
  final List<String> fields;
  final int votes;
  final String userName;
  Suggestion({required this.fields, this.votes = 0, required this.userName});
  Suggestion copyWith({
    List<String>? fields,
    int? votes,
    String? userName,
  }) =>
      Suggestion(
        fields: fields ?? this.fields,
        votes: votes ?? this.votes,
        userName: userName ?? this.userName,
      );

  Map<String, dynamic> toJson() => {
        'fields': fields,
        'votes': votes,
        'userName': userName,
      };

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        fields: [...json['fields'].map((field) => field.toString())],
        userName: json['userName'],
        votes: json['votes'],
      );
}
