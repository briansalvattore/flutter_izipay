import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

class FlutterIzipay {
  Future<String?> getPlatformVersion() {
    return FlutterIzipayPlatform.instance.getPlatformVersion();
  }

  Future<String?> openFormToSaveCard(IziPayConfig config) {
    return FlutterIzipayPlatform.instance.openFormToSaveCard(config.toJson());
  }
}

typedef IziPayConfig = ({
  String environment,
  String merchantCode,
  String publicKey,
  String transactionId,
  String action,
});

extension IziPayConfigExtension on IziPayConfig {
  Map<String, String> toJson() {
    return {
      'environment': environment,
      'merchantCode': merchantCode,
      'publicKey': publicKey,
      'transactionId': transactionId,
      'action': action,
    };
  }
}
