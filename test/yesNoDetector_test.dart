import 'dart:math';

import 'package:test/test.dart';
import 'package:questions_by_ottaa/application/services/YesNoDetector.dart';

void main(){
  final yesNoDetector = YesNoDetector();
  group('Yes No Testing', (){
    test('podes testing', (){
      bool result = yesNoDetector.isYesNo('¿podes subir el volumen?');
      expect(result, true);
    });
    test('puedes testing', (){
      bool result = yesNoDetector.isYesNo('¿puedes subir el volumen?');
      expect(result, true);
    });
    test('tenes testing', (){
      bool result = yesNoDetector.isYesNo('¿Tenes hambre?');
      expect(result, true);
    });
    test('conoces testing', (){
      bool result = yesNoDetector.isYesNo('¿Conoces a pedrito?');
      expect(result, true);
    });
    test('queres testing', (){
      bool result = yesNoDetector.isYesNo('¿Queres tomar coca?');
      expect(result, true);
    });
// question.contains('quieres') || question.contains('vas') || question.contains('ya') || question.contains('tienes') || question.contains('tomaste') || question.contains('es') || question.contains('lo') || question.contains('hace') || question.contains('somos') || question.contains('sos')
    test('How spanish Testing',(){
      bool result = yesNoDetector.isYesNo('How old are you?');
      expect(result,false);
    });
    test('what spanish Testing',(){
      bool result = yesNoDetector.isYesNo('What is your favourite colour?');
      expect(result,false);
    });
    test('what english Testing',(){
      yesNoDetector.setLanguage('en');
      bool result = yesNoDetector.isYesNo('What is your favourite colour?');
      expect(result,false);
    });
    test('How english Testing',(){
      yesNoDetector.setLanguage('en');
      bool result = yesNoDetector.isYesNo('How are you?');
      expect(result,false);
    });
    test('Are Testing',(){
      yesNoDetector.setLanguage('en');
      bool result = yesNoDetector.isYesNo('Are you Hungry?');
      expect(result,true);
    });
    test('empty Testing',(){
      yesNoDetector.setLanguage('es');
      bool result = yesNoDetector.isYesNo('');
      expect(result,false);
    });

    test('what pt Testing',(){
      yesNoDetector.setLanguage('pt');
      bool result = yesNoDetector.isYesNo('What is your favourite colour?');
      expect(result,false);
    });
    test('How pt Testing',(){
      yesNoDetector.setLanguage('pt');
      bool result = yesNoDetector.isYesNo('How are you?');
      expect(result,false);
    });
    test('Are pt Testing',(){
      yesNoDetector.setLanguage('pt');
      bool result = yesNoDetector.isYesNo('Are you Hungry?');
      expect(result,true);
    });

  });
}