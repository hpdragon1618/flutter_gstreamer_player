import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_gstreamer_player/flutter_gstreamer_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: GstPlayer(
                      pipeline:
                        '''rtspsrc location=
                            rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
                          rtph264depay !
                          h264parse !
                          decodebin !
                          videoconvert !
                          video/x-raw,format=RGBA !
                          appsink name=sink''',
                    ),
                  ),
                  Expanded(
                    child: GstPlayer(
                      pipeline:
                        '''rtspsrc location=
                            rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
                          rtph264depay !
                          h264parse !
                          decodebin !
                          videoconvert !
                          video/x-raw,format=RGBA !
                          appsink name=sink''',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: GstPlayer(
                      pipeline:
                        '''rtspsrc location=
                            rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
                          rtph264depay !
                          h264parse !
                          decodebin !
                          videoconvert !
                          video/x-raw,format=RGBA !
                          appsink name=sink''',
                    ),
                  ),
                  Expanded(
                    child: GstPlayer(
                      pipeline:
                        '''rtspsrc location=
                            rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
                          rtph264depay !
                          h264parse !
                          decodebin !
                          videoconvert !
                          video/x-raw,format=RGBA !
                          appsink name=sink''',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
