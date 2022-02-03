class Question {
  final String question;
  final List<QuestionaireOption> options;
  String? _selectedOpton;
  late int _selectedIndexOfOption;

  Question({required this.question, required this.options});

  ///sets the selected answer using the index of the option selected
  ///only sets once, can't change it again if already set
  set setSelectedOption(int index) {
    _selectedIndexOfOption = index;
    _selectedOpton = options[index].option;
  }

  ///returns index of the selected answer
  int get getSelectedAnswerIndex => _selectedIndexOfOption;
  //returns selected answer as String
  String get getSelectedAnswer => _selectedOpton!;
}

class QuestionaireOption {
  final String option;
  final bool expandable;
  final Question? question;

  QuestionaireOption(
      {required this.option, this.expandable = false, this.question});
}

class QuestionaireAnswerSelectedModel {
  final String answer;
  final String question;
  final int answerIndex;
  final String? answerForExtraQuestion;
  final String? extraQuestion;
  final int? answerForExtraQuestionIndex;

  QuestionaireAnswerSelectedModel(
      {required this.answer,
        required this.answerIndex,
        required this.question,
        this.extraQuestion,
        this.answerForExtraQuestion,
        this.answerForExtraQuestionIndex});
}

class QuestionInHealthSection {
  final String _question;
  final List<String> _options;
  final String _selectedAnswer;
  final int _selectedAnswerIndex;
  String get question => _question;
  List<String> get options => _options;
  String get selectedAnswer => _selectedAnswer;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  QuestionInHealthSection(this._question, this._options, this._selectedAnswer,
      this._selectedAnswerIndex);
}