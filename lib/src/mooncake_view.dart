import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooncake/src/table_selector_desktop.dart';
import 'package:mooncake/src/table_selector_mobile.dart';
import 'package:t3_formosa/formosa.dart';

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
  FormosaTheme formosaTheme = FormosaTheme.formosaGLobal;
  int sentenceCount = 1;
  List<String> addedWordToSentence = [];
  late Formosa formosa;

  @override
  void initState() {
    super.initState();
    formosa = Formosa(formosaTheme: formosaTheme);
    setState(() {
      _nOrder = formosa.formosaTheme.data.naturalOrder;
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
                    wLabel: '${_selectedOrderIndex + 1} of ${_nOrder.length} - ($_currentOrder)',
                    onWordSelected: (isValid, word) async {
                      if (isValid) {
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
                                  onPressed: () => Navigator.of(context).pop(addedWordToSentence.join(' ')),
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
                        addedWordToSentence.add(word);
                      }
                    },
                  );
                } else {
                  return SingleChildScrollView(
                    child: TableSelectorDesktop(
                      wordSource: wordSource,
                      wLabel: '${_selectedOrderIndex + 1} of ${_nOrder.length} - ($_currentOrder)',
                      onWordSelected: (isValid, word) async {
                        if (isValid) {
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
                                    onPressed: () => Navigator.of(context).pop(),
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
                          addedWordToSentence.add(word);
                        }
                      },
                    ),
                  );
                }
              }),
    );
  }

  List<String> _getListByOrder(String order) {
    return List.from(formosa.formosaTheme.data[order]["TOTAL_LIST"]);
  }
}
