import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

/// An implementation of [FlutterIzipayPlatform] that uses method channels.
class MethodChannelFlutterIzipay extends FlutterIzipayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_izipay');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> openFormToSaveCard(Map<String, String> config) async {
    final version =
        await methodChannel.invokeMethod<String>('openFormToSaveCard', config);
    return version;
  }
}
