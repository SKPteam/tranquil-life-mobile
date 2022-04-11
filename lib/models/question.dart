class Question {
  int? id;
  String? q1;
  List? q1Options;
  bool? q1IsMultiChoice;
  String? q1Trigger;
  String? q2;
  List? q2Options;

  Question(
      {this.id,
        this.q1,
        this.q1Options,
        this.q1IsMultiChoice,
        this.q1Trigger,
        this.q2,
        this.q2Options});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    q1 = json['q1'];
    q1Options = (json['q1_options'] as List<dynamic>?)!.map((e) => e.toString()).toList();
    q1IsMultiChoice = json['q1_is_multi_choice'];
    q1Trigger = json['q1_trigger'];
    q2 = json['q2'];
    q2Options = (json['q1_options'] as List<dynamic>?)!.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q1'] = this.q1;
    data['q1_options'] = this.q1Options;
    data['q1_is_multi_choice'] = this.q1IsMultiChoice;
    data['q1_trigger'] = this.q1Trigger;
    data['q2'] = this.q2;
    data['q2_options'] = this.q2Options;
    return data;
  }
}
