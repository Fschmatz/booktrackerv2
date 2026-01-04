import 'package:booktrackerv2/pages/configs/app_info.dart';
import 'package:booktrackerv2/pages/configs/changelog.dart';
import 'package:booktrackerv2/pages/lista_livro_imprimir.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:booktrackerv2/util/dialog_select_theme.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../../util/app_details.dart';
import '../../util/dialog_backup.dart';
import '../../util/utils_string.dart';

class Configs extends StatefulWidget {
  Configs({Key? key}) : super(key: key);

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  void _deletarTodosLidos() async {
    await LivroService().deletarLivrosLidos();
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
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: theme.colorScheme.primary,
              child: ListTile(
                title: Text(
                  AppDetails.nomeApp + " " + AppDetails.versaoApp,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17.5, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Text("Geral", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.primary)),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogSelectTheme();
                  }),
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text(
                "Tema do aplicativo",
              ),
              subtitle: Text(
                getThemeStringFormatted(),
              ),
            ),
            ListTile(
              title: Text("Backup", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.primary)),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup(
                      isCreateBackup: true,
                    );
                  }),
              leading: const Icon(Icons.save_outlined),
              title: const Text(
                "Fazer backup",
              ),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup(
                      isCreateBackup: false,
                    );
                  }),
              leading: const Icon(Icons.settings_backup_restore_outlined),
              title: const Text(
                "Restaurar backup",
              ),
            ),
            ListTile(
                leading: const Icon(Icons.print_outlined),
                title: const Text("Listar livros"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ListaLivroImprimir(
                        onlyLidos: false,
                      ),
                      fullscreenDialog: true,
                    ))),
            ListTile(
                leading: const Icon(Icons.print_outlined),
                title: const Text("Listar livros lidos"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ListaLivroImprimir(
                        onlyLidos: true,
                      ),
                      fullscreenDialog: true,
                    ))),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Deletar livros lidos"),
              onTap: () {
                showDialogConfirmDelete(context);
              },
            ),
            ListTile(
              title: Text("Sobre", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.primary)),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                "Informações",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const AppInfo(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.article_outlined,
              ),
              title: const Text(
                "Changelog",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Changelog(),
                    ));
              },
            ),
          ],
        ));
  }
}
