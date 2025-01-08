import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooncake/src/widgets/table_selector_desktop.dart';
import 'package:mooncake/src/widgets/table_selector_mobile.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

class MooncakeView extends StatefulWidget {
  const MooncakeView({super.key});

  @override
  State<MooncakeView> createState() => _MooncakeViewState();
}

class _MooncakeViewState extends State<MooncakeView> {
  int _selectedOrderIndex = 0;
  String _currentOrder = '';
  List<String> _nOrder = [];
  List<String> wordSource = [];
  FormosaTheme formosaTheme = FormosaTheme.global;
  int sentenceCount = 1;
  List<String> addedWordToSentence = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _nOrder = formosaTheme.data.naturalOrder;
      _currentOrder = _nOrder[_selectedOrderIndex];
      wordSource = _getListByOrder(_currentOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wordSource.isEmpty
          ? const SizedBox()
          : LayoutBuilder(builder: (context, constraints) {
              if (Platform.isAndroid || Platform.isIOS) {
                return TableSelectorMobile(
                  wordSource: wordSource,
                  wLabel:
                      '${_selectedOrderIndex + 1} of ${_nOrder.length} - ($_currentOrder)',
                  onWordSelected: (isValid, word) async {
                    if (isValid) {
                      addedWordToSentence.add(word);
                      if (_selectedOrderIndex < _nOrder.length - 1) {
                        _selectedOrderIndex++;
                        _currentOrder = _nOrder[_selectedOrderIndex];
                        wordSource = _getListByOrder(_currentOrder);
                        setState(() {});
                      } else {
                        final value = await showAdaptiveDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog.adaptive(
                            title: const Text("Done"),
                            content: const Text('Process is completed!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  String sentence =
                                      addedWordToSentence.join(' ');
                                  if (sentence.isNotEmpty) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop(sentence);
                                  }
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        _selectedOrderIndex = 0;
                        _currentOrder = _nOrder[_selectedOrderIndex];
                        wordSource = _getListByOrder(_currentOrder);
                        setState(() {});
                        if (context.mounted) {
                          Navigator.of(context).pop(value);
                        }
                      }
                    }
                  },
                );
              } else {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: TableSelectorDesktop(
                      wordSource: wordSource,
                      wLabel:
                          '${_selectedOrderIndex + 1} of ${_nOrder.length} - ($_currentOrder)',
                      onWordSelected: (isValid, word) async {
                        if (isValid) {
                          addedWordToSentence.add(word);
                          if (_selectedOrderIndex < _nOrder.length - 1) {
                            _selectedOrderIndex++;
                            _currentOrder = _nOrder[_selectedOrderIndex];
                            wordSource = _getListByOrder(_currentOrder);
                            setState(() {});
                          } else {
                            await showAdaptiveDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog.adaptive(
                                title: const Text("Done"),
                                content: const Text('Process is completed!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      String sentence = addedWordToSentence.join(' ');
                                      if (sentence.isNotEmpty) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop(sentence);
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            _selectedOrderIndex = 0;
                            _currentOrder = _nOrder[_selectedOrderIndex];
                            wordSource = _getListByOrder(_currentOrder);
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                );
              }
            }),
    );
  }

  List<String> _getListByOrder(String order) {
    return List.from(formosaTheme.data[order]["TOTAL_LIST"]);
  }
}
