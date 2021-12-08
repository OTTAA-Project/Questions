import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
  //     .whenComplete(() => runApp(const MyApp()));
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  // runApp(VoiceMyApp());



  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .whenComplete(() => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body:RegistrationPage(),                 the app first goes to registration or login screen then to MainView

        appBar: AppBar(
          title: Text('Questions'),
          backgroundColor: kColorAppbar,
        ),

        body: MainView(),
      ),
    );
  }
}
//
// class HomeView extends StatelessWidget {
//   HomeView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.brown,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           var screenHeight = constraints.maxHeight;
//           var screenWidth = constraints.maxWidth;
//
//           debugPrint('Max height: $screenHeight, max width: $screenWidth');
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 // Main RED
//                 Container(
//                   constraints: BoxConstraints(
//                       minHeight: screenHeight * 0.8, minWidth: screenWidth),
//                   color: Colors.red,
//
//                   ///////////// ANSWER SECTION
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         height: screenHeight * 0.6,
//                         width: screenWidth * 0.28,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             // image Container
//                             Container(
//                               height: (screenHeight * 0.8) * 0.6,
//                               width: (screenWidth * 0.28) * 0.8,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 border:
//                                     Border.all(width: 4, color: kBorderColor),
//                               ),
//                               child: LayoutBuilder(
//                                 builder: (_, constraints) {
//                                   return Icon(
//                                     Icons.check,
//                                     color: Colors.green,
//                                     size: constraints.biggest.height,
//                                   );
//                                 },
//                               ),
//                             )
//                             // Answer TEXT Container
//                             ,
//                             Container(
//                               child: Text('SI'),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: screenHeight * 0.6,
//                         width: screenWidth * 0.28,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             // image Container
//                             Container(
//                               height: (screenHeight * 0.8) * 0.6,
//                               width: (screenWidth * 0.28) * 0.8,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 border:
//                                     Border.all(width: 4, color: kBorderColor),
//                               ),
//                               child: LayoutBuilder(
//                                 builder: (_, constraints) {
//                                   return Icon(
//                                     Icons.close,
//                                     color: Colors.red,
//                                     size: constraints.biggest.height,
//                                   );
//                                 },
//                               ),
//                             )
//                             // Answer TEXT Container
//                             ,
//                             Container(
//                               child: Text('NO'),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       constraints:
//                           BoxConstraints(minHeight: screenHeight * 0.1),
//                       color: Colors.green,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
