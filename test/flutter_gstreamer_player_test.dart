import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gstreamer_player/flutter_gstreamer_player.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_gstreamer_player');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterGstreamerPlayer.platformVersion, '42');
  });
}
