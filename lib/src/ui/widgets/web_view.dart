// Copyright 2023 Miso Menze
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
// import 'dart:convert';
// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_yoco/src/ui/controllers/flutter_yoco_controller.dart';

/// A webview widget that paints the payment page.
class FlutterYocoWebView extends StatelessWidget {
  const FlutterYocoWebView({super.key, required this.yocoController});
  final FlutterYocoController yocoController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: yocoController.controller),
    );
  }
}
