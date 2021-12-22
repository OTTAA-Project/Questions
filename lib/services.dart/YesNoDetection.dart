import 'dart:developer';
import 'package:diacritic/diacritic.dart';

class QuestionDetection {
  String question = '';
  String language = 'es';
  QuestionDetection() {
    log('===========QuestionDetection Agent Started');
  }

  bool isYesNo(String question) {
    question = question.toLowerCase();
    switch (language) {
      case "es":
        {
          question = removeDiacritics(question);

          int i = question.indexOf(' ');
          if (i != -1) question = question.substring(0, i);

          final answer = question.contains('podes') ||
              question.contains('puedes') ||
              question.contains('tenes') ||
              question.contains('conoces') ||
              question.contains('queres') ||
              question.contains('quieres') ||
              question.contains('vas') ||
              question.contains('ya') ||
              question.contains('tienes') ||
              question.contains('tomaste') ||
              question.contains('es') ||
              question.contains('lo') ||
              question.contains('hace') ||
              question.contains('somos') ||
              question.contains('sos');
          return answer;
        }

      case "en":
        {
          switch (question.substring(0, 2)) {
            case "wh":
              return false;
            case "ho":
              return false;
            default:
              return true;
          }
        }
      default:
        {
          switch (question.substring(0, 2)) {
            case "wh":
              return false;
            case "ho":
              return false;
            default:
              return true;
          }
        }
    }
  }
}
