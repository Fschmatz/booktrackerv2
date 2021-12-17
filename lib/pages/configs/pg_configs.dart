import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/configs/pg_app_info.dart';
import 'package:booktrackerv2/pages/configs/pg_changelog.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import '../../util/changelog.dart';
import 'package:provider/provider.dart';

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
                "App Info",
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
            const SizedBox(
              height: 10.0,
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
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                  title: const Text(
                    "Tema Escuro",
                    style: TextStyle(fontSize: 16),
                  ),
                  secondary: const Icon(Icons.brightness_6_outlined),
                  activeColor: Colors.blue,
                  value: notifier.darkTheme,
                  onChanged: (value) {
                    notifier.toggleTheme();
                  }),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Deletar Todos os Livros Lidos",
                  style: TextStyle(
                      fontSize: 16)),
              onTap: () {showAlertDialogOkDelete(context);},
            ),
          ],
        ));
  }
}
