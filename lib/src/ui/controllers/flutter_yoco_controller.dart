import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_yoco/src/types/yoco_payment.dart';
import 'package:flutter_yoco/src/ui/widgets/flutter_yoco.dart';
import 'package:webview_all/webview_all.dart';

// dart format lib/src/controllers/flutter_yoco_controller.dart

class FlutterYocoController {
  final FlutterYoco widget;
  final void Function(int progress) onProgress;
  final void Function(String url, YocoPayment transaction) onUrlStarted;
  late final Webview _controller;

  FlutterYocoController({
    required this.widget,
    required this.onProgress,
    required this.onUrlStarted,
  });

  Future<void> init() async {
    if (kDebugMode) {
      print('Flutter_yoco: Initializing controller...');
    }

    if (!isValidUrls()) {
      if (kDebugMode) {
        print('Flutter_yoco: initialization failed, urls are equal');
      }
      throw Exception('Urls cannot be equal');
    }

    if (!endsWithSlash(widget.successUrl) ||
        !endsWithSlash(widget.cancelUrl) ||
        !endsWithSlash(widget.failureUrl)) {
      if (kDebugMode) {
        print(
            'Flutter_yoco: initialization failed, urls must end with a slash');
      }
      throw Exception('Urls must end with a slash');
    }

    /// Create payment
    final payment = await createPayment();

    if (payment == null) {
      throw Exception('Payement could not be created');
    }

    _controller = _initController(payment);
  }

  Webview get controller => _controller;

  /// Initializes the controller.
  Webview _initController(YocoPayment payment) {
    return Webview(url: payment.redirectUrl);
  }

  Future<YocoPayment?> createPayment() async {
    final dio = Dio();
    final amount_in_cents = widget.amount * 100;
    final body = {
      "amount": amount_in_cents,
      "currency": "ZAR",
      "externalId": widget.transactionId,
      "successUrl": widget.successUrl,
      "cancelUrl": widget.cancelUrl,
      "failureUrl": widget.failureUrl,
    };
    print('Flutter_yoco: ${body}');
    dio.options.headers["Authorization"] = "Bearer ${widget.secretKey}";
    dio.options.headers["Content-Type"] = "application/json";
    const url = 'https://payments.yoco.com/api/checkouts';
    try {
      final response = await dio.post(url, data: body);
      final payment = YocoPayment.fromJson(response.data);
      return payment;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Ensure that the urls are not equal
  ///
  bool isValidUrls() {
    return widget.successUrl != widget.cancelUrl &&
        widget.successUrl != widget.failureUrl &&
        widget.cancelUrl != widget.failureUrl;
  }

  bool endsWithSlash(String url) {
    return url.endsWith('/');
  }
}
