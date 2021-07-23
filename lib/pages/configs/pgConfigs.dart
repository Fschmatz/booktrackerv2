import 'package:booktrackerv2/pages/configs/pgAppInfo.dart';
import 'package:booktrackerv2/pages/configs/pgChangelog.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import '../../util/changelog.dart';
import 'package:provider/provider.dart';

class PgConfigs extends StatefulWidget {
  @override
  _PgConfigsState createState() => _PgConfigsState();

  PgConfigs({Key? key}) : super(key: key);
}

class _PgConfigsState extends State<PgConfigs> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Card(
              elevation: 1,
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ListTile(
                title: Text(
                  Changelog.nomeApp + " " + Changelog.versaoApp,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.5, color: Colors.black),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: SizedBox(height: 0.1,),
              title:    Text(
                  "Sobre".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).accentColor)
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
              ),
              title: Text(
                "App Info",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => PgAppInfo(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            ListTile(
              leading: Icon(
                Icons.article_outlined,
              ),
              title: Text(
                "Changelog",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => PgChangelog(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            const Divider(),
            ListTile(
              leading: SizedBox(height: 0.1,),
              title:    Text(
                  "Geral".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).accentColor)
              ),
            ),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                  title: Text(
                    "Tema Escuro",
                    style: TextStyle(fontSize: 16),
                  ),
                  secondary: Icon(Icons.brightness_6_outlined),
                  activeColor: Colors.blue,
                  value: notifier.darkTheme,
                  onChanged: (value) {
                    notifier.toggleTheme();
                  }),
            ),
          ],
        ));
  }
}
