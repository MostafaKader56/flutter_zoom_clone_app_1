import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZEGO ZOOM CLONE',
      home: HomePage(),
    );
  }
}

// Generate userId 6 digit length
// Generate conferenceId with 10 digit length
final String userId = Random().nextInt(900000 + 100000).toString();
final String randomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final conferenceIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://1000logos.net/wp-content/uploads/2021/06/Zoom-Logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            Text('Your User: $userId'),
            const Text('Please test '),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Join a meeting by input an ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  JumbToMeetingPage(context,
                      conferanceId: conferenceIdController.text);
                },
                child: const Text('Join Meeting')),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  JumbToMeetingPage(context, conferanceId: randomConferenceId);
                },
                child: Text('New Meeting')),
          ],
        ),
      ),
    );
  }

  void JumbToMeetingPage(BuildContext context, {required String conferanceId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VideoConferancePage(conferanceID: conferanceId)));
  }
}

class VideoConferancePage extends StatelessWidget {
  VideoConferancePage({super.key, required this.conferanceID});

  final String conferanceID;
  final int appId = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');
  

  @override
  Widget build(BuildContext context) {
    print('conferanceID: $conferanceID');
    return SafeArea(

      child: ZegoUIKitPrebuiltVideoConference(
        appID: appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user_$userId',
        conferenceID: conferanceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),

    );
  }
}
