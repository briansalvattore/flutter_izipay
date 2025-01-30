import 'package:flutter_izipay/flutter_izipay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterIzipayPlatform extends PlatformInterface {
  FlutterIzipayPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIzipayPlatform _instance = MethodChannelFlutterIzipay();

  static FlutterIzipayPlatform get instance => _instance;

  static set instance(FlutterIzipayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Map<String, dynamic>> resultStream() {
    throw UnimplementedError('resultStream() has not been implemented.');
  }

  Future<void> openFormToSaveCard(Map<String, String> allConfigs) {
    throw UnimplementedError('openFormToSaveCard() has not been implemented.');
  }

  Future<void> payWithCard(Map<String, String> allConfigs) {
    throw UnimplementedError('openFormToPay() has not been implemented.');
  }

  Future<void> payWithYape(Map<String, String> allConfigs) {
    throw UnimplementedError('openFormToPay() has not been implemented.');
  }
}
