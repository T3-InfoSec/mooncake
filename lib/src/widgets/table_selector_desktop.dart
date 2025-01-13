import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TableSelectorDesktop extends StatefulWidget {
  const TableSelectorDesktop({
    super.key,
    required this.wordSource,
    required this.onWordSelected,
    required this.wLabel,
  });

  final List<String> wordSource;
  final String wLabel;
  final Function(bool, String) onWordSelected;

  @override
  State<TableSelectorDesktop> createState() => _TableSelectorDesktopState();
}

class _TableSelectorDesktopState extends State<TableSelectorDesktop> {
  List<String> keyboardCharacters = ['a', 's', 'd', 'f', 'j', 'k', 'l', ';'];
  Set<String> trackSets = {};

  bool isKeySetable = false;
  String setableKeysCandidate = '';
  final FocusNode keysNode = FocusNode();

  _validateKeySetable(String value) {
    final enteredKeys = value.toLowerCase().replaceAll(' ', '').split('');
    trackSets = enteredKeys.toSet();

    // Update the state if exactly 8 unique keys are provided
    isKeySetable = trackSets.length == 8;
    setState(() {});
  }

  _setKeys() {
    if (trackSets.length == 8) {
      keyboardCharacters = trackSets.toList();
      _generateLabelsAndGridWords();
      keysNode.nextFocus();
      setState(() {});
    }
  }

  String _userInput = '';
  List<String>? _horizontalLabels;
  List<String>? _verticalLeftLabels;
  List<String>? _verticalRightLabels;
  List<String>? _gridWords;

  final FocusNode _focusNode = FocusNode();
  bool highlight = true;

  @override
  void initState() {
    super.initState();
    _generateLabelsAndGridWords();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TableSelectorDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wordSource != oldWidget.wordSource) {
      _generateLabelsAndGridWords();
    }
  }

  void _generateLabelsAndGridWords() {
    final horizontalLabels = List.of(keyboardCharacters)..shuffle();
    final verticalLeftLabels = _generateShuffledLeftLabels();
    final verticalRightLabels = _generateRepeatedRightLabels(verticalLeftLabels.length, verticalLeftLabels);
    final gridWords = _generateGridWordsWithLabels(
        horizontalLabels, verticalLeftLabels, verticalRightLabels, 32, horizontalLabels.length);

    setState(() {
      _horizontalLabels = horizontalLabels;
      _verticalLeftLabels = verticalLeftLabels;
      _verticalRightLabels = verticalRightLabels;
      _gridWords = gridWords;
    });
  }

  List<String> _generateShuffledLeftLabels() {
    List<List<String>> leftLabels = [];
    for (var char in keyboardCharacters) {
      leftLabels.add(List.filled(8, char));
    }
    leftLabels.shuffle();
    return leftLabels.expand((x) => x).toList();
  }

  List<String> _generateRepeatedRightLabels(int length, List<String> leftLabels) {
    List<String> repeatedRightLabels = [];

    while (repeatedRightLabels.length < length) {
      repeatedRightLabels.addAll(keyboardCharacters..shuffle());
    }
    repeatedRightLabels = repeatedRightLabels.take(length).toList();

    for (int i = 0; i < repeatedRightLabels.length; i++) {
      int swapIndex = i;
      int sameCharCount = 0;

      for (int j = i + 1; j < repeatedRightLabels.length; j++) {
        if (leftLabels[i] == repeatedRightLabels[i]) {
          sameCharCount++;
        }

        if (_isValidSwap(repeatedRightLabels, i, j, leftLabels, sameCharCount)) {
          swapIndex = j;
          break;
        }
      }

      if (swapIndex != i) {
        String temp = repeatedRightLabels[i];
        repeatedRightLabels[i] = repeatedRightLabels[swapIndex];
        repeatedRightLabels[swapIndex] = temp;
      }
    }

    return repeatedRightLabels;
  }

  bool _isValidSwap(List<String> list, int i, int j, List<String> leftLabels, int sameCharCount) {
    if (list[j] == leftLabels[i] && sameCharCount > 1) {
      return false;
    }

    if (i >= 8) {
      for (int k = 1; k <= 8; k++) {
        if (list[i - k] == list[j]) {
          return false;
        }
      }
    }

    return true;
  }

  List<String> _generateGridWordsWithLabels(
      List<String> topLabels, List<String> leftLabels, List<String> rightLabels, int rowCount, int colCount) {
    List<String> combinedWords = [];
    int wordIndex = 0;

    // Shuffle the wordSource to get random words
    List<String> shuffledWordSource = List.from(widget.wordSource);

    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < colCount; col++) {
        String combinedLabel = '${topLabels[col]}${leftLabels[row]}${rightLabels[row]}';

        // Ensure that we don't exceed the number of available unique words
        if (wordIndex >= shuffledWordSource.length) {
          break; // Exit if there are not enough unique words
        }

        String word = shuffledWordSource[wordIndex];
        combinedWords.add('$combinedLabel-$word');
        wordIndex++;
      }
    }

    return combinedWords;
  }

  // This function handles the keyboard input
  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey.keyLabel.toLowerCase();

      // If Enter or Tab is pressed, trigger word selection
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _handleSelection();
        return;
      }

      // If Escape is pressed, reset input
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() {
          _userInput = '';
        });
        return;
      }

      // Add input if it's a valid character
      if (keyboardCharacters.contains(key)) {
        setState(() {
          _userInput += key; // Append valid key to the user input
        });
      }

      // Handle Backspace for correcting input
      if (event.logicalKey == LogicalKeyboardKey.backspace && _userInput.isNotEmpty) {
        setState(() {
          _userInput = '';
        });
        return;
      }
    }
  }

  // Function to handle the word selection based on user input
  void _handleSelection() {
    bool isHighlighted = false;

    for (var gridWord in _gridWords!) {
      String gridKey = gridWord.split('-')[0].toLowerCase();
      String word = gridWord.split('-')[1].toLowerCase();
      if (_userInput == gridKey) {
        isHighlighted = true;
        widget.onWordSelected(isHighlighted, word);
        break;
      }
    }

    // Reset the user input after selection
    setState(() {
      _userInput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_horizontalLabels == null ||
        _verticalLeftLabels == null ||
        _verticalRightLabels == null ||
        _gridWords == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wLabel),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                highlight = !highlight;
              });
            },
            child: Row(
              children: [
                const Text('Highlight:'),
                Checkbox.adaptive(
                  value: highlight,
                  onChanged: (v) {
                    setState(() {
                      highlight = v ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double cellSize = (constraints.maxHeight / (_horizontalLabels!.length + 3)).clamp(40.0, 100.0);
            const int rows = 32;
            final double gridHeight = cellSize * rows;

            return Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     _userInput.toLowerCase(),
                //     style: const TextStyle(fontSize: 18),
                //   ),
                // ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 64),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.info_outline),
                          Text('Provide custom keys in the text field bellow, tap for more information'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                focusNode: keysNode,
                                onTap: () {
                                  _focusNode.nextFocus();
                                  keysNode.requestFocus();
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  labelText: keyboardCharacters.join(', '),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  border: InputBorder.none,
                                  fillColor: Colors.deepPurple.withValues(alpha: 0.3),
                                  filled: true,
                                ),
                                maxLength: 8,
                                onChanged: (value) {
                                  _validateKeySetable(value);
                                },
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: isKeySetable ? () => _setKeys() : null,
                            child: const Text('Set Keys'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      
                GestureDetector(
                  onTap: () {
                    keysNode.nextFocus();
                    _focusNode.requestFocus();
                  },
                  child: RawKeyboardListener(
                    focusNode: _focusNode,
                    onKey: keysNode.hasFocus ? null : _handleKey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: cellSize),
                              ..._horizontalLabels!.map((label) => Container(
                                    width: cellSize,
                                    height: cellSize,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.black, width: 0.5),
                                      ),
                                    ),
                                    child: Text(label),
                                  )),
                              SizedBox(width: cellSize),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: cellSize,
                                height: gridHeight,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: _verticalLeftLabels!
                                        .map((label) => Container(
                                              width: cellSize,
                                              height: cellSize,
                                              alignment: Alignment.centerRight,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(color: Colors.black, width: 0.5),
                                                ),
                                              ),
                                              child: Text(label.toUpperCase()),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _horizontalLabels!.length,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemCount: _gridWords!.length,
                                  itemBuilder: (context, index) {
                                    String gridWord = _gridWords![index].split('-')[0].toLowerCase();
                                    bool isHighlighted = highlight && gridWord == _userInput.toLowerCase();

                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isHighlighted ? Colors.green.withOpacity(0.3) : Colors.transparent,
                                        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
                                      ),
                                      child: Text(
                                        _gridWords![index],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                  width: cellSize,
                                  height: gridHeight,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: _verticalRightLabels!
                                          .map((label) => Container(
                                                width: cellSize,
                                                height: cellSize,
                                                alignment: Alignment.centerLeft,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: Colors.black, width: 0.5),
                                                  ),
                                                ),
                                                child: Text(label),
                                              ))
                                          .toList(),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
