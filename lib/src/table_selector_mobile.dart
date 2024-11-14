import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mooncake/src/controller/indexation.dart';
import 'package:mooncake/src/grid_builder.dart';
import 'package:mooncake_plugin/mooncake_plugin.dart';

class TableSelectorMobile extends StatefulWidget {
  const TableSelectorMobile({
    required this.wordSource,
    required this.onWordSelected,
    required this.wLabel,
    super.key,
  });

  final List<String> wordSource;
  final Function(bool, String) onWordSelected;
  final String wLabel;

  @override
  State<TableSelectorMobile> createState() => _TableSelectorMobileState();
}

class _TableSelectorMobileState extends State<TableSelectorMobile> {
  final indexationService = IndexationService(colCount: 8, rowCount: 4, itemsPerPage: 32);

  List<String> colIndexes = [];
  List<String> rowIndexes = [];
  List<String> words = [];
  int currentPage = 0;

  bool higlight = true;

  String selectedIndexationCombination = '';
  String possibleCombination = '';

  int get totalPages => (widget.wordSource.length / indexationService.itemsPerPage).ceil();

  @override
  void didUpdateWidget(covariant TableSelectorMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wordSource != oldWidget.wordSource) {
      _reset();
      _startUp();
    }
  }

  Future<void> _startListeningForVolumeTap() async {
    
    MooncakePlugin.listenForVolumeButtonPress(
      (event) {
        if (event.pressType.isLongPress) {
          _handlePageChange(event.button);
        } else {
          _handleInput(event.button);
        }
      },
    );
  }

  void _handlePageChange(VolumeButton button) {
    if (button.isUp) {
      _goToNextPage();
    } else {
      _goToPreviousPage();
    }
  }

  void _handleInput(VolumeButton button) {
    /// hence they are always the same length,we'd want use the index count
    /// to know if we are ready to validate the input and higlight or move to the next page/items
    possibleCombination += button.value;

    final indexationItemCount = rowIndexes.first.length + colIndexes.first.length;

    if (possibleCombination.length == indexationItemCount) {
      // ready to validate
      _validateIndexationSelection(possibleCombination);
    } else if (possibleCombination.length > indexationItemCount) {
      _reset();
    }
  }

  _validateIndexationSelection(String input) async {
    final colLength = colIndexes.first.length;

    // Extract column and row combinations from input
    String colCombination = input.substring(0, colLength);
    String rowCombination = input.substring(colLength, input.length);

    // Check if the combinations exist in the colIndex and rowIndex
    if (colIndexes.contains(colCombination) && rowIndexes.contains(rowCombination)) {
      selectedIndexationCombination = input;
      final word = _getWordByIndexationCombination(indexationCombination: selectedIndexationCombination);
      if (word.isEmpty) {
        _reset();
        return;
      }
      if (higlight) {
        Future.delayed(const Duration(seconds: 2), () {
          widget.onWordSelected(true, word);
        });
      } else {
        await _gotToAllPagesUntillEnd();
        currentPage = 0;
        widget.onWordSelected(true, word);
      }
    } else {
      // invalid selection, reset
      _reset();
    }
    setState(() {});
  }

  String _getWordByIndexationCombination({
    required String indexationCombination,
  }) {
    final index = indexationService.getIndexByCombination(
      indexationCombination: indexationCombination,
      rowIndexes: rowIndexes,
      colIndexes: colIndexes,
    );

    if (index >= 0 && index < words.length) {
      return words[index];
    } else {
      return '';
    }
  }

  _reset() {
    setState(() {
      possibleCombination = '';
      selectedIndexationCombination = '';
      // other reset logic
    });
  }

  _startUp() {
    colIndexes = indexationService.colIndexes;
    rowIndexes = indexationService.rowIndexes;
    words = _getWordsForCurrentPage();
    _randomizeIndexation();
  }

  void _randomizeIndexation() {
    setState(() {
      colIndexes.shuffle();
      rowIndexes.shuffle();
    });
  }

  List<String> _getWordsForCurrentPage() {
    int start = currentPage * indexationService.itemsPerPage;
    int end = start + indexationService.itemsPerPage;
    return widget.wordSource.sublist(start, end > widget.wordSource.length ? widget.wordSource.length : end);
  }

  void _goToNextPage() {
    if (currentPage < totalPages - 1) {
      setState(() {
        currentPage++;
        _randomizeIndexation();
      });
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _randomizeIndexation();
      });
    }
  }

  Future<void> _gotToAllPagesUntillEnd() async {
    final random = Random();
    for (int i = 0; i < totalPages; i++) {
      currentPage = i;
      _reset();
      int randomDelay = 2000 + random.nextInt(3500);
      await Future.delayed(Duration(milliseconds: randomDelay));
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startListeningForVolumeTap();
    _startUp();
  }

  @override
  Widget build(BuildContext context) {
    words = _getWordsForCurrentPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.reset_tv),
            onPressed: () {
              setState(() {
                _reset();
              });
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                higlight = !higlight;
              });
            },
            child: Row(
              children: [
                const Text('Highlight:'),
                Checkbox.adaptive(
                  value: higlight,
                  onChanged: (v) {
                    higlight = v ?? false;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexWordGridBuilder(
          wordSource: words,
          colIndexes: colIndexes,
          rowIndexes: rowIndexes,
          showHighlight: higlight,
          selectedIndexationCombination: selectedIndexationCombination,
        ),
      ),
    );
  }
}
