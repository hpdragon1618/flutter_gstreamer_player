
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GstPlayerTextureController {
  static const MethodChannel _channel = MethodChannel('flutter_gstreamer_player');

  int textureId = 0;
  static int _id = 0;

  Future<int> initialize(String pipeline) async {
    // No idea why, but you have to increase `_id` first before pass it to method channel,
    // if not, receiver of method channel always received 0
    GstPlayerTextureController._id = GstPlayerTextureController._id + 1;

    textureId = await _channel.invokeMethod('PlayerRegisterTexture', {
      'pipeline': pipeline,
      'playerId': GstPlayerTextureController._id,
    });

    return textureId;
  }

  Future<Null> dispose() {
      return _channel.invokeMethod('dispose', {'textureId': textureId});
  }

  bool get isInitialized => textureId != null;
}

class GstPlayer extends StatefulWidget {
  String pipeline;

  GstPlayer({Key? key, required this.pipeline}) : super(key: key);

  @override
  State<GstPlayer> createState() => _GstPlayerState();
}

class _GstPlayerState extends State<GstPlayer> {
  final _controller = GstPlayerTextureController();

  @override
  void initState() {
    initializeController();
    super.initState();
  }

  @override
  void didUpdateWidget(GstPlayer oldWidget) {
    if (widget.pipeline != oldWidget.pipeline) {
      initializeController();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<Null> initializeController() async {
    await _controller.initialize(
      widget.pipeline,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    switch (currentPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.android:
        return Container(
          child: _controller.isInitialized
            ? Texture(textureId: _controller.textureId)
            : null,
        );
        break;
      case TargetPlatform.iOS:
        String viewType = _controller.textureId.toString();
        final Map<String, dynamic> creationParams = <String, dynamic>{};
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
