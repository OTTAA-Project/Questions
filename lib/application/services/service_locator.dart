import 'package:get_it/get_it.dart';
import 'package:questions_by_ottaa/application/services/YesNoDetector.dart';
import 'package:questions_by_ottaa/core/services/questions_service.dart';

final locator = GetIt.instance;

Future<void> setupServices() async {
  locator.registerFactory<QuestionsService>(() => YesNoDetector());
}
