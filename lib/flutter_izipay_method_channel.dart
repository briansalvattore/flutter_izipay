import 'package:flutter/services.dart';
import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

class MethodChannelFlutterIzipay extends FlutterIzipayPlatform {
  final methodChannel = const MethodChannel('flutter_izipay/method_channel');
  final eventChannel = const EventChannel('flutter_izipay/event_channel');

  @override
  Stream<Map<String, dynamic>> resultStream() {
    return eventChannel.receiveBroadcastStream().map(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
        );
  }

  @override
  Future<void> openFormToSaveCard(Map<String, String> allConfigs) async {
    return methodChannel.invokeMethod<void>('openFormToSaveCard', allConfigs);
  }

  @override
  Future<void> payWithCard(Map<String, String> allConfigs) async {
    return methodChannel.invokeMethod<void>('payWithCard', allConfigs);
  }

  @override
  Future<void> payWithYape(Map<String, String> allConfigs) async {
    return methodChannel.invokeMethod<void>('payWithYape', allConfigs);
  }
}
