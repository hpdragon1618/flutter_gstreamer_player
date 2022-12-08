import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_gstreamer_player/flutter_gstreamer_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget initMultipleGstPlayer(List<String> pipelines) {
    // Try this: https://stackoverflow.com/a/66421214
    List<Widget> videoListWidget = [];
    for (var i = 0; i < pipelines.length - 1; i = i + 2){
      videoListWidget.add(
        Expanded(
          child: Row(
            children: <Widget> [
              Expanded(
                child: GstPlayer(
                  pipeline: pipelines[i],
                ),
              ),
              Expanded(
                child: GstPlayer(
                  pipeline: pipelines[i+1],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (pipelines.length.isOdd) {
      videoListWidget.add(
        Expanded(
          child: Row(
            children: <Widget> [
              Expanded(
                child: GstPlayer(
                  pipeline: pipelines.last,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget multipleGstPlayer = Column(
          children: videoListWidget,
        );

    return multipleGstPlayer;
  }

  @override
  Widget build(BuildContext context) {
    List<String> pipelines = [];

    switch (defaultTargetPlatform) {
      case (TargetPlatform.linux):
      case (TargetPlatform.android):
        pipelines.addAll([
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            videoconvert !
            video/x-raw,format=RGBA !
            appsink name=sink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            videoconvert !
            video/x-raw,format=RGBA !
            appsink name=sink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            videoconvert !
            video/x-raw,format=RGBA !
            appsink name=sink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            videoconvert !
            video/x-raw,format=RGBA !
            appsink name=sink''',
        ]);
        break;
      case (TargetPlatform.iOS):
        pipelines.addAll([
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            glimagesink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            glimagesink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            glimagesink''',
          '''rtspsrc location=
              rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 !
            decodebin !
            glimagesink''',
        ]);
        break;
      default:
        break;
    }

    Widget multipleGstPlayer = initMultipleGstPlayer(pipelines);

    return MaterialApp(
      home: Scaffold(
        body: multipleGstPlayer,
      ),
    );
  }
}
