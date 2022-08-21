package com.hpdragon1618.flutter_gstreamer_player

import android.content.Context
import androidx.annotation.NonNull
import android.view.Surface
import android.graphics.SurfaceTexture

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.TextureRegistry

import android.util.Log

/** FlutterGstreamerPlayerPlugin */
class FlutterGstreamerPlayerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var entries: MutableList<TextureRegistry.SurfaceTextureEntry> = mutableListOf()

  external fun handlePlayerRegisterTexture(pipeline: String, playerId: Int, surface: Any): Int

  companion object {
    lateinit var messenger: BinaryMessenger;
    lateinit var context: Context;
    lateinit var registry: TextureRegistry;
    lateinit var assets: FlutterPlugin.FlutterAssets;

    init {
      System.loadLibrary("gstreamer_android")
      System.loadLibrary("flutter_gstreamer_player_plugin_android")
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_gstreamer_player")
    channel.setMethodCallHandler(this)

    messenger = flutterPluginBinding.binaryMessenger;
    context = flutterPluginBinding.applicationContext;
    registry = flutterPluginBinding.textureRegistry;
    assets = flutterPluginBinding.flutterAssets;
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "PlayerRegisterTexture") {
      val arguments = call.arguments as Map<String, Any>;
      var pipeline = arguments["pipeline"] as String;
      var player_id = arguments["playerId"] as Int;

      entries.add(registry.createSurfaceTexture())
      var surfaceTexture = entries[entries.lastIndex].surfaceTexture()
      var textureID = entries[entries.lastIndex].id().toInt();

      var surface = Surface(surfaceTexture)

      handlePlayerRegisterTexture(pipeline, player_id, surface);

      result.success(textureID);
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
