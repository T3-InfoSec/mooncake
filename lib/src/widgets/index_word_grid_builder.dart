import 'package:flutter/material.dart';
import 'package:mooncake/src/widgets/combination_icons.dart';

class IndexWordGridBuilder extends StatelessWidget {
  const IndexWordGridBuilder({
    required this.colIndexes,
    required this.rowIndexes,
    required this.wordSource,
    required this.showHighlight,
    required this.selectedIndexationCombination,
    super.key,
  });

  final List<String> colIndexes;
  final List<String> rowIndexes;
  final List<String> wordSource;
  final bool showHighlight;
  final String selectedIndexationCombination;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    final columns = isLandscape ? colIndexes.length : rowIndexes.length;
    final rows = isLandscape ? rowIndexes.length : colIndexes.length;

    final cellWidth = size.width / (columns + 1);
    final cellHeight = size.height / (rows + 1) * 0.6;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: cellWidth,
              height: cellHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300]?.withOpacity(0.1),
              ),
            ),
            ...colIndexes.map((col) => Container(
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey[300]?.withOpacity(0.3),
                  ),
                  width: cellWidth - 10,
                  height: cellHeight,
                  alignment: Alignment.center,
                  child: CombinationIcons(combinationString: col, iconSize: 15),
                )),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Column(
                children: rowIndexes
                    .map((row) => Container(
                          margin: const EdgeInsets.only(bottom: 4, top: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300]?.withOpacity(0.3),
                          ),
                          width: cellWidth,
                          height: cellHeight,
                          alignment: Alignment.center,
                          child: CombinationIcons(combinationString: row, iconSize: 15),
                        ))
                    .toList(),
              ),
              Column(
                children: List.generate(rows, (rowIndex) {
                  return Row(
                    children: List.generate(columns, (colIndex) {
                      final index = rowIndex * columns + colIndex;
                      final randomizedRowIndex = rowIndexes[rowIndex];
                      final randomizedColIndex = colIndexes[colIndex];
                      if (wordSource.isEmpty) {
                        return Container();
                      }
                      final word = wordSource[index];
                      // Determine if this cell should be highlighted
                      final combinedIndex = randomizedColIndex + randomizedRowIndex;
                      bool isHighlighted = (combinedIndex == selectedIndexationCombination);
                      return Container(
                        margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4, top: 8),
                        padding: const EdgeInsets.all(4),
                        width: cellWidth - 10,
                        height: cellHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (showHighlight && isHighlighted) ? Colors.green.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          word,
                          style: TextStyle(
                            color: (showHighlight && isHighlighted) ? Colors.green : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
