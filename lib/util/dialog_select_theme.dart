import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class DialogSelectTheme extends StatefulWidget {
  const DialogSelectTheme({Key? key}) : super(key: key);

  @override
  State<DialogSelectTheme> createState() => _DialogSelectThemeState();
}

class _DialogSelectThemeState extends State<DialogSelectTheme> {
  final List<String> _themes = ['ThemeMode.light', 'ThemeMode.dark', 'ThemeMode.system'];

  int _getSelectedThemeIndex(dynamic currentTheme) {
    if (currentTheme.toString() == _themes[0]) return 0;
    if (currentTheme.toString() == _themes[1]) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode? currentTheme = EasyDynamicTheme.of(context).themeMode;
    Color appAccent = Theme.of(context).colorScheme.primary;

    return AlertDialog(
      title: const Text('Selecionar tema'),
      content: SizedBox(
        width: 280.0,
        child: RadioGroup<int>(
          groupValue: _getSelectedThemeIndex(currentTheme),
          onChanged: (int? newValue) {
            if (newValue == 0) EasyDynamicTheme.of(context).changeTheme(dark: false);
            if (newValue == 1) EasyDynamicTheme.of(context).changeTheme(dark: true);
            if (newValue == 2) EasyDynamicTheme.of(context).changeTheme(dynamic: true);

            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                value: 0,
                activeColor: appAccent,
                title: const Text('Claro'),
              ),
              RadioListTile<int>(
                value: 1,
                activeColor: appAccent,
                title: const Text('Escuro'),
              ),
              RadioListTile<int>(
                value: 2,
                activeColor: appAccent,
                title: const Text('Padrão do sistema'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
