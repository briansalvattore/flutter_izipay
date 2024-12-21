import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_izipay/flutter_izipay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterIzipayPlugin = FlutterIzipay();

  @override
  void initState() {
    super.initState();

    _flutterIzipayPlugin.resultStream.listen((data) {
      print('data');
      print(data.success);
      print(data.cardToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  final random =
                      356547157 + Random().nextInt(366547157 - 356547157);

                  _flutterIzipayPlugin.openFormToSaveCard(
                    config: (
                      environment: 'SBOX',
                      merchantCode: '4004353',
                      publicKey: 'VErethUtraQuxas57wuMuquprADrAHAb',
                      transactionId: '$random',
                    ),
                    user: (
                      userId: '1234567890',
                      firstName: 'Juan',
                      lastName: 'Perez',
                      email: 'juan.perez@example.com',
                      phoneNumber: '999999999',
                      documentType: 'DNI',
                      documentNumber: '12345678',
                    ),
                    address: (
                      street: 'Calle 123',
                      city: 'Lima',
                      state: 'Lima',
                      country: 'PE',
                      postalCode: '12345',
                    ),
                    theme: (
                      logoUrl:
                          'https://www.ensalza.com/blog/wp-content/uploads/que-es-jpg.png',
                    ),
                  );
                },
                child: const Text('Abrir form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
