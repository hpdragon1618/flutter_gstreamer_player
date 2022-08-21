#include "gst_player.h"

#include <string.h>
#include <jni.h>
#include <android/log.h>
#include <android/native_window.h>
#include <android/native_window_jni.h>

#define LOG_TAG                       "flutter_gstreamer_player_plugin_android"
#define ANATIVEWINDOW_BUFFER_FORMAT   AHARDWAREBUFFER_FORMAT_R8G8B8A8_UNORM

static jint
handle_player_register_texture(JNIEnv * env, jobject thiz, jstring pipeline, jint player_id, jobject surface) {
  const char *pipelineString = env->GetStringUTFChars(pipeline, 0);

  ANativeWindow *native_window = ANativeWindow_fromSurface (env, surface);

  __android_log_print (ANDROID_LOG_INFO,
      LOG_TAG,
      "pipeline: %s, player_id: %d",
      pipelineString,
      player_id);

  GstPlayer* gstPlayer = g_players->Get(player_id);

  gstPlayer->onVideo([
          native_window = native_window
        ](
          uint8_t* frame,
          uint32_t size,
          int32_t width,
          int32_t height,
          int32_t stride) -> void {
      if (native_window != NULL) {
        ANativeWindow_Buffer nativeBuffer;

        if (ANativeWindow_lock(native_window, &nativeBuffer, NULL) == 0) {
          if (nativeBuffer.width != width || nativeBuffer.height != height) {
            ANativeWindow_unlockAndPost(native_window);
            ANativeWindow_setBuffersGeometry(native_window,
                width,
                height,
                ANATIVEWINDOW_BUFFER_FORMAT);
            if (ANativeWindow_lock(native_window, &nativeBuffer, NULL) != 0) {
              return;
            }
          }

          uint32_t pixelSize = size / (width * height);
          for (int h = 0; h < height; h++) {
            memcpy((void*)((long)nativeBuffer.bits + h * nativeBuffer.stride * pixelSize),
                frame + h*stride,
                width * pixelSize);
          }
          ANativeWindow_unlockAndPost(native_window);
        }
      }
    }
  );

  gstPlayer->play(pipelineString);

  env->ReleaseStringUTFChars(pipeline, pipelineString);

  return 0;
}

/* List of implemented native methods */
static JNINativeMethod native_methods[] = {
  {"handlePlayerRegisterTexture", "(Ljava/lang/String;ILjava/lang/Object;)I",
      (void *) handle_player_register_texture},
};

/* Library initializer */
jint
JNI_OnLoad (JavaVM * vm, void *reserved)
{
  JNIEnv *env = NULL;

  if (vm->GetEnv ((void **) &env, JNI_VERSION_1_4) != JNI_OK) {
    __android_log_print (ANDROID_LOG_ERROR, LOG_TAG,
        "Could not retrieve JNIEnv");
    return 0;
  }
  jclass klass = env->FindClass (
      "com/hpdragon1618/flutter_gstreamer_player/FlutterGstreamerPlayerPlugin");
  env->RegisterNatives (klass, native_methods,
      G_N_ELEMENTS (native_methods));

  return JNI_VERSION_1_4;
}
