import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger
  private var pipeline: String

  init(messenger: FlutterBinaryMessenger, pipeline: String) {
    self.messenger = messenger
    self.pipeline = pipeline
    super.init()
  }

  func create(
      withFrame frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?
  ) -> FlutterPlatformView {
    return FLNativeView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger,
      pipeline: self.pipeline)
  }
}

class FLNativeView: NSObject, FlutterPlatformView {
  private var _view: UIView
  //private var _pipeline: String = ""
  private var _gStreamerBackend: GStreamerBackend

  init(
      frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?,
      binaryMessenger messenger: FlutterBinaryMessenger?,
      pipeline pipeline: String
  ) {
    _view = UIView()

    /*
    print("[FLNativeView] viewId: " + String(viewId))
    switch (viewId) {
      case 0:
        //_pipeline = "videotestsrc pattern=smpte ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 1:
        //_pipeline = "videotestsrc pattern=circular ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 2:
        //_pipeline = "videotestsrc pattern=checkers-8 ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 3:
        //_pipeline = "videotestsrc pattern=smpte100 ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      default:
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
    }
    */
    _gStreamerBackend = GStreamerBackend(
      pipeline,
      videoView: _view)

    super.init()
    // iOS views can be created here
    //createNativeView(view: _view)
  }

  func view() -> UIView {
    return _view
  }

  func createNativeView(view _view: UIView){
    _view.backgroundColor = UIColor.blue
    let nativeLabel = UILabel()
    nativeLabel.text = "Native text from iOS: " + String("")
    nativeLabel.textColor = UIColor.white
    nativeLabel.textAlignment = .center
    nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
    _view.addSubview(nativeLabel)
  }
}

public class SwiftFlutterGstreamerPlayerPlugin: NSObject, FlutterPlugin {

  static var registrar: FlutterPluginRegistrar? = nil;
  /* static var factory: FLNativeViewFactory? = nil; */

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_gstreamer_player", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterGstreamerPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    gst_ios_init()

    SwiftFlutterGstreamerPlayerPlugin.registrar = registrar
    /* SwiftFlutterGstreamerPlayerPlugin.factory = factory */
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
      case "PlayerRegisterTexture":
        guard let args = call.arguments as? [String : Any] else {
          result(" arguments error.... ")
          return
        }
        let pipeline = args["pipeline"] as! String;
        let playerId = args["playerId"] as! Int64;

        /* guard let factory = SwiftFlutterGstreamerPlayerPlugin.factory as? FLNativeViewFactory else { */
        /*   print("Internal plugin error: factory does not initialized") */
        /*   return */
        /* } */
        guard let registrar = SwiftFlutterGstreamerPlayerPlugin.registrar as? FlutterPluginRegistrar else {
          print("Internal plugin error: registrar does not initialized")
          return
        }

        var factory = FLNativeViewFactory(messenger: registrar.messenger(), pipeline: pipeline)
        registrar.register(factory, withId: String(playerId))

        result(playerId)
        break
      default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
}
