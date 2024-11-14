library mooncake;

import 'package:flutter/material.dart';
import 'package:mooncake/src/mooncake_view.dart';

class Mooncake {
  static Future<String?> show(BuildContext context) async {
    final result = await showDialog<String?>(context: context, builder: (context) => const MooncakeView());

    return result;
  }
}
