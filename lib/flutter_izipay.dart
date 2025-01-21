import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

class FlutterIzipay {
  Stream<IziPayResult> get resultStream {
    return FlutterIzipayPlatform.instance.resultStream().map((e) {
      return (
        success: (e['success'] as bool?) ?? false,
        cardToken: e['cardToken'] as String?,
        cardPan: e['cardPan'] as String?,
        cardBrand: e['cardBrand'] as String?,
      );
    });
  }

  Future<void> openFormToSaveCard({
    required IziPayConfig config,
    required String transactionId,
    required IziPayUser user,
    required IziPayAddress address,
    required IziPayTheme theme,
    String webhookUrl = '_blank',
  }) {
    return FlutterIzipayPlatform.instance.openFormToSaveCard({
      ...config.toJson(),
      'transactionId': transactionId,
      'orderNumber': _adjust13Length(transactionId),
      'webhookUrl': webhookUrl,
      ...user.toJson(),
      ...address.toJson(),
      ...theme.toJson(),
    });
  }

  String _adjust13Length(String value) {
    if (value.length > 13) {
      return value.substring(value.length - 13);
    }

    return value.padLeft(13, '0');
  }
}

typedef IziPayResult = ({
  bool success,
  String? cardToken,
  String? cardPan,
  String? cardBrand,
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
    };
  }
}
