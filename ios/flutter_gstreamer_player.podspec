#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_gstreamer_player.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_gstreamer_player'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.frameworks = 'CoreFoundation', 'Foundation', 'AVFoundation', 'CoreMedia', 'CoreVideo', 'CoreAudio', 'AudioToolbox', 'OpenGLES', 'AssetsLibrary', 'QuartzCore', 'AssetsLibrary', 'VideoToolBox',       'Metal', 'IOSurface'
  s.vendored_frameworks = 'GStreamer.framework'
  s.xcconfig              = {
    'HEADER_SEARCH_PATHS' => [
        '"$(HOME)/Library/Developer/GStreamer/iPhone.sdk/GStreamer.framework/Headers"'
    ],
    'FRAMEWORK_SEARCH_PATHS' => [
        '"$(HOME)/Library/Developer/GStreamer/iPhone.sdk"',
        '"$(SYSTEM_APPS_DIR)/Xcode.app/Contents/Developer/Library/Frameworks"'
    ],
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }
  s.library = 'iconv', 'resolv', 'c++', ''
end
