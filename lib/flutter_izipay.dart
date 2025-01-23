import 'package:flutter_izipay/flutter_izipay_platform_interface.dart';

class FlutterIzipay {
  final kIzipaySuccess = '00';

  Stream<IziPayResult> get resultStream {
    return FlutterIzipayPlatform.instance.resultStream().map((e) {
      final code = (e['code'] as String?) ?? '';

      return (
        success: code == kIzipaySuccess,
        code: code,
        card: IziPayCardExtension.fromJson(e),
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

  Future<void> payDirectly({
    required IziPayConfig config,
    required String transactionId,
    required String amount,
    required IziPayUser user,
    required IziPayAddress address,
    required IziPayTheme theme,
    String webhookUrl = '_blank',
  }) {
    return FlutterIzipayPlatform.instance.openFormToPay({
      ...config.toJson(),
      'transactionId': transactionId,
      'orderNumber': _adjust13Length(transactionId),
      'webhookUrl': webhookUrl,
      'amount': amount,
      ...user.toJson(),
      ...address.toJson(),
      ...theme.toJson(),
    });
  }
}

typedef IziPayResult = ({
  bool success,
  String code,
  IziPayCard card,
});

typedef IziPayCard = ({
  String cardToken,
  String cardPan,
  String cardBrand,
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

extension IziPayCardExtension on IziPayCard {
  static IziPayCard fromJson(Map<String, dynamic> json) {
    return (
      cardToken: (json['cardToken'] as String?) ?? '',
      cardPan: (json['cardPan'] as String?) ?? '',
      cardBrand: (json['cardBrand'] as String?) ?? '',
    );
  }

  static IziPayCard withToken(String cardToken) {
    return (
      cardToken: cardToken,
      cardPan: '',
      cardBrand: '',
    );
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
