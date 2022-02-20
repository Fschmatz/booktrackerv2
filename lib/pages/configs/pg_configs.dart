import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/configs/pg_app_info.dart';
import 'package:booktrackerv2/pages/configs/pg_changelog.dart';
import 'package:booktrackerv2/util/dialog_lista_lidos.dart';
import 'package:booktrackerv2/util/dialog_select_theme.dart';
import 'package:booktrackerv2/util/utils_functions.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../../util/changelog.dart';

class PgConfigs extends StatefulWidget {

  @override
  _PgConfigsState createState() => _PgConfigsState();

  Function()? refresh;

  PgConfigs({Key? key, this.refresh}) : super(key: key);
}

class _PgConfigsState extends State<PgConfigs> {

  void _deletarTodosLidos() async {
    final dbLivro = LivroDao.instance;
    final deletado = await dbLivro.deleteTodosLidos();
  }

  String getThemeStringFormatted(){
    String theme =  EasyDynamicTheme.of(context).themeMode.toString().replaceAll('ThemeMode.', '');
    if(theme == 'system'){
      theme = 'padrão do sistema';
    }else if (theme == 'light'){
      theme = 'claro';
    }else {
      theme = 'escuro';
    }
    return capitalizeFirstLetterString(theme);
  }


  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Sim",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
      ),
      onPressed: () {
        _deletarTodosLidos();
        if(widget.refresh != null) {
          widget.refresh!();
        }
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: const Text(
        "Confirmação ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "\nDeletar ?",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              elevation: 1,
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                title: Text(
                  Changelog.nomeApp + " " + Changelog.versaoApp,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17.5, color: Colors.black),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const SizedBox(
                height: 0.1,
              ),
              title: Text("Geral".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary)),
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
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                getThemeStringFormatted(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Deletar todos os livros lidos",
                  style: TextStyle(
                      fontSize: 16)),
              onTap: () {showAlertDialogOkDelete(context);},
            ),
            ListTile(
              leading: const Icon(Icons.print_outlined),
                title: const Text("Listar todos os livros lidos",
                    style: TextStyle(
                        fontSize: 16)),
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogListaLidos();
                  }),
            ),
            const Divider(),
            ListTile(
              leading: const SizedBox(
                height: 0.1,
              ),
              title: Text("Sobre".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary)),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                "Informações do aplicativo",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PgAppInfo(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.article_outlined,
              ),
              title: const Text(
                "Changelog",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PgChangelog(),
                      fullscreenDialog: true,
                    ));
              },
            ),
          ],
        ));
  }
}
