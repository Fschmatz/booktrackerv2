import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/versaoNomeChangelog.dart';
import 'package:provider/provider.dart';

class Configs extends StatefulWidget {
  @override
  _ConfigsState createState() => _ConfigsState();

  Function() refreshTema;
  Configs({Key key,this.refreshTema}) : super(key: key);
}

class _ConfigsState extends State<Configs> {
  bool exibirLidos = false;

  @override
  void initState() {
    getExibirLidos();
    super.initState();
  }

  //bool exibirLidos = false;
  Future<void>  getExibirLidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    exibirLidos = prefs.getBool('valorExibirLidos');
    setState(() {});
  }

  saveExibirTemas(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('valorExibirLidos', exibirLidos);
  }



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
                elevation: 3.0,
                margin: const EdgeInsets.all(2.0),
                color: Colors.yellow,
                child: ListTile(
                  title: Text(
                    "Flutter " +
                        versaoNomeChangelog.nomeApp +
                        " " +
                        versaoNomeChangelog.versaoApp,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),

                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Opções: ",
                style: TextStyle(fontSize: 21),
              ),
              SizedBox(
                height: 15.0,
              ),

              ListTile(
                contentPadding: const EdgeInsets.all(0),
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
                        widget.refreshTema();
                      }),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  "Sempre Exibir Livro Terminados",
                  style: TextStyle(fontSize: 18),
                ),
                trailing:Switch(
                      activeColor: Colors.blue,
                      value: exibirLidos,
                      onChanged: (bool value) {

                        saveExibirTemas(value);
                        setState(() {
                          exibirLidos = value;
                        });

                      }),
                ),

              /*Divider(
                thickness: 1,
              ),*/
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
