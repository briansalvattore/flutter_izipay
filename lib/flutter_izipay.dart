import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

class FlutterIzipay {
  Stream<IziPayResult> get resultStream {
    return FlutterIzipayPlatform.instance.resultStream().map((e) {
      return (
        success: (e['success'] as bool?) ?? false,
        cardToken: e['cardToken'] as String?,
      );
    });
  }

  Future<void> openFormToSaveCard({
    required IziPayConfig config,
    required IziPayUser user,
    required IziPayAddress address,
    required IziPayTheme theme,
  }) {
    return FlutterIzipayPlatform.instance.openFormToSaveCard({
      ...config.toJson(),
      ...user.toJson(),
      ...address.toJson(),
      ...theme.toJson(),
    });
  }
}

typedef IziPayResult = ({
  bool success,
  String? cardToken,
});

typedef IziPayConfig = ({
  String environment,
  String merchantCode,
  String publicKey,
  String transactionId,
});

typedef IziPayUser = ({
  String userId,
  String firstName,
  String lastName,
  String email,
  String phoneNumber,
  String documentType,
  String documentNumber,
});

typedef IziPayAddress = ({
  String street,
  String city,
  String state,
  String country,
  String postalCode,
});

typedef IziPayTheme = ({
  String logoUrl,
});

extension IziPayAddressExtension on IziPayAddress {
  Map<String, String> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }
}

extension IziPayThemeExtension on IziPayTheme {
  Map<String, String> toJson() {
    return {
      'logoUrl': logoUrl,
    };
  }
}

extension IziPayUserExtension on IziPayUser {
  Map<String, String> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'documentType': documentType,
      'documentNumber': documentNumber,
    };
  }
}

extension IziPayConfigExtension on IziPayConfig {
  Map<String, String> toJson() {
    return {
      'environment': environment,
      'merchantCode': merchantCode,
      'publicKey': publicKey,
      'transactionId': transactionId,
    };
  }
}
