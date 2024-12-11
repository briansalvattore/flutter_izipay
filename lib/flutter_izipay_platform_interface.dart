import 'package:flutter_izipay/flutter_izipay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterIzipayPlatform extends PlatformInterface {
  /// Constructs a FlutterIzipayPlatform.
  FlutterIzipayPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIzipayPlatform _instance = MethodChannelFlutterIzipay();

  /// The default instance of [FlutterIzipayPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIzipay].
  static FlutterIzipayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIzipayPlatform] when
  /// they register themselves.
  static set instance(FlutterIzipayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> openFormToSaveCard(Map<String, String> config) {
    throw UnimplementedError('openFormToSaveCard() has not been implemented.');
  }
}
