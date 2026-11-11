import 'package:booktrackerv2/pages/app_info.dart';
import 'package:booktrackerv2/pages/changelog.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../redux/build_context_extension.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';
import '../util/backup_utils.dart';
import '../util/dialog_backup.dart';
import '../util/dialog_select_grid_size.dart';
import '../util/dialog_select_theme.dart';
import '../util/utils_string.dart';
import '../widgets/app_parameter_value.dart';
import '../widgets/settings_switch.dart';
import 'lista_livro_imprimir.dart';

class Configs extends StatefulWidget {
  Configs({Key? key}) : super(key: key);

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  bool _restaurandoBackup = false;

  void _deletarTodosLidos() async {
    await LivroService().deletarLivrosLidos();
  }

  void _fazerBackup() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DialogBackup(
          isCreateBackup: true,
        );
      },
    );

    if (confirmar == true) {
      await BackupUtils().backupData();
    }
  }

  void _restaurarBackup() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DialogBackup(
          isCreateBackup: false,
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        _restaurandoBackup = true;
      });

      try {
        await BackupUtils().restoreBackupData();
      } finally {
        if (mounted) {
          setState(() {
            _restaurandoBackup = false;
          });
        }
      }
    }
  }

  String getThemeStringFormatted() {
    String theme = EasyDynamicTheme.of(context).themeMode.toString().replaceAll('ThemeMode.', '');
    if (theme == 'system') {
      theme = 'padrão do sistema';
    } else if (theme == 'light') {
      theme = 'claro';
    } else {
      theme = 'escuro';
    }
    return UtilsString.capitalizeFirstLetterString(theme);
  }

  showDialogConfirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmação",
          ),
          content: const Text(
            "Deletar ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Sim",
              ),
              onPressed: () {
                _deletarTodosLidos();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final useGrid = context.select((state) => selectParameterValueByKeyAsBoolean(state, AppConstants.useHomeGridAppParameter, defaultValue: false));
    final showResumeCard =
        context.select((state) => selectParameterValueByKeyAsBoolean(state, AppConstants.showResumePageCardAppParameter, defaultValue: false));

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 75),
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    AppConstants.nomeApp,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versão ${AppConstants.versaoApp}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Geral",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const DialogSelectTheme();
                          },
                        ),
                        leading: const Icon(Icons.brightness_6_outlined),
                        title: const Text("Tema do aplicativo"),
                        subtitle: Text(
                          getThemeStringFormatted(),
                        ),
                      ),
                      const Divider(),
                      const SettingsSwitch(
                        title: "Usar grid",
                        parameterKey: AppConstants.useHomeGridAppParameter,
                        subtitle: 'Exibir os livros em grid na página inicial',
                        defaultValue: false,
                      ),
                      const Divider(),
                      ListTile(
                        enabled: useGrid,
                        onTap: useGrid
                            ? () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const DialogSelectGridSize(
                                      parameterKey: AppConstants.gridSizeAppParameter,
                                      defaultValue: 3,
                                    );
                                  },
                                )
                            : null,
                        title: const Text("Livros por linha no grid"),
                        subtitle: const Row(
                          children: [
                            AppParameterValue(
                              parameterKey: AppConstants.gridSizeAppParameter,
                              defaultValue: '3',
                            ),
                            Text(" livros"),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SettingsSwitch(
                        title: "Exibir card de resumo",
                        parameterKey: AppConstants.showResumePageCardAppParameter,
                        subtitle: 'Exibir um card de resumo na página inicial',
                        defaultValue: false,
                      ),
                      const Divider(),
                      SettingsSwitch(
                        enabled: showResumeCard,
                        title: "Card de resumo sempre expandido",
                        parameterKey: AppConstants.expandResumePageCardAppParameter,
                        subtitle: 'Manter os detalhes do resumo expandidos por padrão',
                        defaultValue: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Backup e Dados",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: _restaurandoBackup ? null : _fazerBackup,
                        leading: const Icon(Icons.save_outlined),
                        title: const Text("Fazer backup"),
                        subtitle: const Row(
                          children: [
                            Text("Último backup: "),
                            AppParameterValue(parameterKey: AppConstants.lastBackupDateAppParameter),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        enabled: !_restaurandoBackup,
                        onTap: _restaurandoBackup ? null : _restaurarBackup,
                        leading: const Icon(Icons.settings_backup_restore_outlined),
                        title: const Text("Restaurar backup"),
                        trailing: _restaurandoBackup
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : null,
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.print_outlined),
                        title: const Text("Listar livros"),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ListaLivroImprimir(onlyLidos: false),
                            fullscreenDialog: true,
                          ),
                        ),
                      ),
                      /*
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.print_outlined),
                        title: const Text("Listar livros lidos"),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ListaLivroImprimir(onlyLidos: true),
                            fullscreenDialog: true,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text("Deletar livros lidos"),
                        onTap: () {
                          showDialogConfirmDelete(context);
                        },
                      ),
                      */
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Sobre",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("Informações"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const AppInfo(),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: const Text("Changelog"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const Changelog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
