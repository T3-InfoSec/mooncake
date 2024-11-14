import 'package:flutter/material.dart';

class CombinationIcons extends StatelessWidget {
  const CombinationIcons({
    required this.combinationString,
    this.iconSize = 32,
    this.iconColor,
    super.key,
  });

  final String combinationString;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    List<String> upDowns = combinationString.split('');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        upDowns.length,
        (index) {
          String ud = upDowns[index];

          switch (ud) {
            case '1':
              return Icon(Icons.arrow_upward, size: iconSize, color: iconColor);
            case '0':
              return Icon(Icons.arrow_downward, size: iconSize, color: iconColor);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
