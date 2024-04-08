import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/configs/app_info.dart';
import 'package:booktrackerv2/pages/configs/changelog.dart';
import 'package:booktrackerv2/pages/lista_livro_imprimir.dart';
import 'package:booktrackerv2/util/dialog_select_theme.dart';
import 'package:booktrackerv2/util/utils_functions.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../../util/app_details.dart';
import '../../util/dialog_backup.dart';

class Configs extends StatefulWidget {
  @override
  _ConfigsState createState() => _ConfigsState();

  Function()? refresh;

  Configs({Key? key, this.refresh}) : super(key: key);
}

class _ConfigsState extends State<Configs> {
  void _deletarTodosLidos() async {
    final dbLivro = LivroDao.instance;
    await dbLivro.deleteTodosLidos();
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
    return capitalizeFirstLetterString(theme);
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
                if (widget.refresh != null) {
                  widget.refresh!();
                }
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
                      reloadHomeFunction: widget.refresh,
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
                      reloadHomeFunction: widget.refresh,
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
