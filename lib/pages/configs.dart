import 'package:booktrackerv2/pages/about.dart';
import 'package:booktrackerv2/pages/changelog.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import '../util/versaoNomeChangelog.dart';
import 'package:provider/provider.dart';

class Configs extends StatefulWidget {
  @override
  _ConfigsState createState() => _ConfigsState();

  Configs({Key key}) : super(key: key);
}

class _ConfigsState extends State<Configs> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                elevation: 1.0,
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                color: Theme.of(context).accentColor,
                child: ListTile(
                  title: Text(
                        versaoNomeChangelog.nomeApp +
                        " Fschmtz " +
                        versaoNomeChangelog.versaoApp,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.5, color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline,),
                title: Text(
                  "Sobre",
                  style: TextStyle(fontSize: 17.5),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => About(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.text_snippet_outlined),
                title: Text(
                  "Changelog",
                  style: TextStyle(fontSize: 17.5),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Changelog(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              const SizedBox(
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 0, 5, 0),
                child: Text(
                    "Geral:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .textTheme
                          .headline6
                          .color
                          .withOpacity(0.7),)
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),

              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => SwitchListTile(
                    title: Text(
                      "Tema Escuro",
                      style: TextStyle(fontSize: 17.5),
                    ),
                    activeColor: Colors.blue,
                    value: notifier.darkTheme,
                    onChanged: (value) {
                      notifier.toggleTheme();
                    }),
              ),
            ],
          ),
        ));
  }
}
