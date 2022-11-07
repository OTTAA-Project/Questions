import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questions_by_ottaa/application/providers/providers.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';
import 'package:questions_by_ottaa/presentation/home/ui/microphone_button.dart';
import 'package:questions_by_ottaa/presentation/home/ui/pictos_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hProvider = ref.watch(homeProvider);
    final size = MediaQuery.of(context).size;
    final tts = ref.watch(ttsProvider);
    SttRepository stt;

    if (kIsWeb) {
      stt = ref.watch(webSTTProvider);
    } else {
      stt = ref.watch(sttProvider);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: hProvider.onVerticalDragUpdate,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          stt.text == '' ? '' : stt.text,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: PictosResult(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Toca el micrófono y haz una pregunta',
                          style: TextStyle(fontSize: 17.0.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: hProvider.left,
                top: hProvider.top,
                child: const MicrophoneButton(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Powered by',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        'assets/images/ottaa_logo_drawer.png',
                        height: size.width * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
