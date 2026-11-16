import '../../generated/protocol.dart';

abstract final class TeachingPolicy {
  static void validate(
    TeachingSettings s,
    String kind,
    List<TeachingQuestion> questions, {
    bool publish = false,
  }) {
    if (!{'assignment', 'test'}.contains(kind) ||
        s.title.trim().isEmpty ||
        s.title.length > 200 ||
        s.instructions.length > 20000 ||
        !s.maxPoints.isFinite ||
        s.maxPoints <= 0 ||
        s.maxPoints > 10000 ||
        (s.opensAt != null &&
            s.closesAt != null &&
            !s.closesAt!.isAfter(s.opensAt!)) ||
        s.attemptLimit < 1 ||
        s.attemptLimit > 10 ||
        s.timeLimitMinutes < 1 ||
        s.timeLimitMinutes > 240 ||
        (!s.allowText && !s.allowFile && kind == 'assignment')) {
      throw TeachingError(code: 'invalid_settings');
    }
    if (questions.length > 100 ||
        (kind == 'test' &&
            publish &&
            (questions.isEmpty || s.closesAt == null))) {
      throw TeachingError(code: 'invalid_questions');
    }
    for (final q in questions) {
      if (!{'choice', 'trueFalse'}.contains(q.kind) ||
          q.prompt.trim().isEmpty ||
          q.prompt.length > 4000 ||
          q.options.length < 2 ||
          q.options.length > 8 ||
          (q.kind == 'trueFalse' && q.options.length != 2) ||
          q.options.any((v) => v.trim().isEmpty || v.length > 1000) ||
          q.correctIndex == null ||
          q.correctIndex! < 0 ||
          q.correctIndex! >= q.options.length ||
          !q.points.isFinite ||
          q.points <= 0 ||
          q.points > 10000) {
        throw TeachingError(code: 'invalid_questions');
      }
    }
  }

  static double score(
    List<TeachingQuestion> questions,
    List<int> answers,
    double maximum,
  ) {
    final total = questions.fold<double>(0, (v, q) => v + q.points);
    final earned = questions.indexed.fold<double>(
      0,
      (v, entry) =>
          v +
          (answers[entry.$1] == entry.$2.correctIndex ? entry.$2.points : 0),
    );
    return total == 0
        ? 0
        : double.parse((earned / total * maximum).toStringAsFixed(2));
  }

  static bool available(TeachingSettings settings, DateTime now) =>
      (settings.opensAt == null || !now.isBefore(settings.opensAt!)) &&
      (settings.closesAt == null || now.isBefore(settings.closesAt!));
  static void answers(List<TeachingQuestion> questions, List<int> answers) {
    if (answers.length != questions.length ||
        answers.indexed.any(
          (e) => e.$2 < -1 || e.$2 >= questions[e.$1].options.length,
        )) {
      throw TeachingError(code: 'invalid_answers');
    }
  }
}
