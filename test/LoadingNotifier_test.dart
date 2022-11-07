import 'package:test/test.dart';
import 'package:questions_by_ottaa/application/notifiers/loading_notifier.dart';

void main(){
  var notifier = LoadingNotifier();
  group('Loading notifier testing', (){
    test('true status',(){
      notifier.showLoading();
      bool result = notifier.isLoading;
      expect(result, true);
    });
    test('false status',(){
      notifier.hideLoading();
      bool result = notifier.isLoading;
      expect(result, false);
    });

    test('toogle status',(){
      notifier.hideLoading();
      notifier.toggleLoading();
      bool result = notifier.state;
      expect(result, true);
    });

  });

}