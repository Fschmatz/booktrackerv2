import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import '../class/app_parameter.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';

class DialogSelectGridSize extends StatelessWidget {
  final String parameterKey;
  final int defaultValue;

  const DialogSelectGridSize({
    super.key,
    required this.parameterKey,
    this.defaultValue = 3,
  });

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.state<AppState>(context);
    final currentValueStr = selectParameterValueByKey(state, parameterKey);
    final int currentVal = int.tryParse(currentValueStr ?? '') ?? defaultValue;
    final Color appAccent = Theme.of(context).colorScheme.primary;

    final sortedKeys = AppConstants.mapGrid.keys.toList()..sort();

    return AlertDialog(
      title: const Text('Livros por linha no grid'),
      content: SizedBox(
        width: 280.0,
        child: RadioGroup<int>(
          groupValue: currentVal,
          onChanged: (int? newValue) {
            if (newValue != null) {
              StoreProvider.dispatch(
                context,
                SaveAppParameterAction(
                  AppParameter(
                    key: parameterKey,
                    value: newValue.toString(),
                  ),
                ),
              );
            }
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sortedKeys.map((val) {
              return RadioListTile<int>(
                value: val,
                activeColor: appAccent,
                title: Text('$val ${val == 1 ? 'livro' : 'livros'}'),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
