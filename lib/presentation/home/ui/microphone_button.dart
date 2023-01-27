import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questions_by_ottaa/application/providers/providers.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';
import 'package:questions_by_ottaa/presentation/theme.dart';

class MicrophoneButton extends ConsumerWidget {
  const MicrophoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SttRepository stt;

    if (kIsWeb) {
      stt = ref.watch(webSTTProvider);
    } else {
      stt = ref.watch(sttProvider);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFBB86FC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          bottomLeft: Radius.circular(60.0),
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.menu, color: kBackgroundColor, size: 40),
          const SizedBox(width: 5),
          AvatarGlow(
            glowColor: Colors.white,
            endRadius: 40.0,
            duration: const Duration(seconds: 2),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            animate: stt.isRecognizing,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF03DAC5),
                fixedSize: const Size.fromRadius(30),
              ),
              onPressed: () async {
                if (!stt.isRecognizing) {
                  final uri = await AudioCache().load('start.mp3');

                  final player = AudioPlayer();
                  await player.play(DeviceFileSource(uri.path));

                  await stt.startRecording();
                } else {
                  await stt.stopRecording();
                }
              },
              icon: stt.isRecognizing ? const Icon(Icons.mic_rounded) : const Icon(Icons.mic_none_rounded),
              iconSize: 30,
              color: kBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
