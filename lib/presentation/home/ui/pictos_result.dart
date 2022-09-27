import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picto_widget/picto_widget.dart';
import 'package:questions_by_ottaa/application/providers/providers.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';

class PictosResult extends ConsumerWidget {
  const PictosResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogFlow = ref.watch(dialogFlowProvider);
    if (dialogFlow.subDataMapList[0][0]['label']!.isEmpty) return const SizedBox();

    SttRepository stt;

    if (kIsWeb) {
      stt = ref.watch(webSTTProvider);
    } else {
      stt = ref.watch(sttProvider);
    }

    if (stt.isQuestion) {
      return Row(
        children: [],
      );
    }

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: PictoWidget(
            text: dialogFlow.subDataMapList[0][0]['label']!,
            onTap: () {},
            imageUrl: dialogFlow.subDataMapList[0][0]['url']!,
          ),
        ),
        Expanded(
          child: PictoWidget(
            text: dialogFlow.subDataMapList[0][1]['label']!,
            onTap: () {},
            imageUrl: dialogFlow.subDataMapList[0][1]['url']!,
          ),
        ),
        Expanded(
          child: PictoWidget(
            text: dialogFlow.subDataMapList[0][2]['label']!,
            onTap: () {},
            imageUrl: dialogFlow.subDataMapList[0][2]['url']!,
          ),
        ),
        Expanded(
          child: PictoWidget(
            text: dialogFlow.subDataMapList[0][3]['label']!,
            onTap: () {},
            imageUrl: dialogFlow.subDataMapList[0][3]['url']!,
          ),
        ),
      ],
    );
  }
}
