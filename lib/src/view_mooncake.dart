import 'package:flutter/material.dart';
import 'package:mooncake/src/widgets/mooncake_view.dart';

Future<String?> startMooncake(BuildContext context) async {
  return await showDialog<String?>(context: context, builder: (context) => const MooncakeView());
}
