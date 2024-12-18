import 'package:flutter/services.dart';

class IndexationService {
  IndexationService({
    required this.colCount,
    required this.rowCount,
    required this.itemsPerPage,
  });
//TODO: may increase base on screen size
  int itemsPerPage = 32;
  // use itemsPerPage to determine how many items per column
  int colCount = 8;
  // use itemsPerPage to determine how many items per row
  int rowCount = 4;

  //TODO: use this to determine which is row or col  (default to landscape)
  DeviceOrientation? deviceOrientation;
// for now indexes are fixed to 3 for col and 2 for row, this should be dynamic based on (grid size, itemsPerPage) which is based on screen size
  List<String> get colIndexes => List.generate(colCount, (index) => index.toRadixString(2).padLeft(3, '0'));
  List<String> get rowIndexes => List.generate(rowCount, (index) => index.toRadixString(2).padLeft(2, '0'));

  // TODO: method to use words per page, screen size and orientation to calculate how many items per row and column
  _determineItemsPerRowAndColumn() {
    if (deviceOrientation == DeviceOrientation.landscapeLeft || deviceOrientation == DeviceOrientation.landscapeRight) {
      // always use page size to determine items per row and column
      // i.e how many items can go in a row and column
      // if in landscape mode and size is 32, then 8 columns and 4 rows can fit perfectly (also depends on screen size), this should be dynamic
      // the bigger the size, the more items per page, and the more columns and rows
    }
  }

  String binaryToSymbol(String binaryInput) {
    // converts a list of binary strings to a list of symbols
    // 001 => down-down-up
    List<String> binaryList = binaryInput.split('');
    return binaryList.map((binary) {
      if (binary == '0') {
        return 'down';
      } else {
        return 'up';
      }
    }).join('-');
  }

  String symbolToBinary(String symbolInput) {
    // converts a symbol to a binary string
    // down-down-up => 001
    List<String> symbolList = symbolInput.split('-');
    return symbolList.map((symbol) {
      if (symbol == 'down') {
        return '0';
      } else {
        return '1';
      }
    }).join('');
  }

  int getIndexByCombination({
    required String indexationCombination,
    required List<String> colIndexes,
    required List<String> rowIndexes,
  }) {
    final colLength = colIndexes.first.length;
    final colCombination = indexationCombination.substring(0, colLength);
    final rowCombination = indexationCombination.substring(colLength);

    final colIndex = colIndexes.indexOf(colCombination);
    final rowIndex = rowIndexes.indexOf(rowCombination);

    if (colIndex == -1 || rowIndex == -1) {
      throw Exception('Invalid indexation combination');
    }

    // Calculate and return the combined index
    return rowIndex * colIndexes.length + colIndex;
  }
}
