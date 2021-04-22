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
          centerTitle: true,
          elevation: 0.0,
        ),

        body: Stack(
        children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                elevation: 2.0,
                margin: const EdgeInsets.all(2.0),
                color: Theme.of(context).accentColor,
                child: ListTile(
                  title: Text(
                        versaoNomeChangelog.nomeApp +
                        " Fschmtz " +
                        versaoNomeChangelog.versaoApp,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                    color:  Colors.grey[800].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  leading: Icon(Icons.text_snippet_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 18),
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
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                    color:  Colors.grey[800].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  leading: Icon(Icons.text_snippet_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(
                    "Changelog",
                    style: TextStyle(fontSize: 18),
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
              ),
              const SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  "Opções: ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),

              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                title: Text(
                  "Tema Escuro",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Switch(
                      activeColor: Colors.blue,
                      value: notifier.darkTheme,
                      onChanged: (value) {
                        notifier.toggleTheme();
                      }),
                ),
              ),

              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
