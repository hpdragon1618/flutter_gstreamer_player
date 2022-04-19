# GStreamer Player Plugin

A GStreamer-powered alternative to Flutter's video_player that support Linux.

![](doc/screenshot.png)

## Installation

Follow GStreamer's [Install on Linux](https://gstreamer.freedesktop.org/documentation/installing/on-linux.html?gi-language=c) instuction

## Getting Started

To start using the plugin, copy this code or follow the example project in `example`

```
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
        body: GstPlayer(
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
      ),
    );
  }
}
```

## License

Copyright (c) 2022, Nguyen Hoai Phong <phongnh.36@gmail.com>.

This library & work under this repository is licensed under MIT License.
