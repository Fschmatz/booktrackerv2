import 'package:booktrackerv2/util/changelog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PgAppInfo extends StatelessWidget {

  _launchGithub() async {
    const url = 'https://github.com/Fschmatz/booktrackerv2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("App Info"),
          elevation: 0.0,
        ),
        body: ListView(children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.yellow[600],
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(Changelog.nomeApp + " " + Changelog.versaoApp,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          const SizedBox(height: 15),
          const Divider(),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Dev".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              "MARTELADO E REFEITO DO ZERO: 1 X POR ENQUANTO !!!\n( Por causa de um problema grave do SDK, culpa do Flutter! )\nVamos que Vamos, denovo!!!",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text(
              "Aplicativo criado utilizando o Flutter e a linguagem Dart, usado para testes e aprendizado.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Código Fonte".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            onTap: () {_launchGithub();},
            leading: Icon(Icons.open_in_new_outlined),
            title: Text("Ver no Github",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue)),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Quote".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(Icons.messenger_outline),
            title: Text(
              ''' 
“The capacity to learn is a gift; 
the ability to learn is a skill; 
the willingness to learn is a choice.” 
– Brian Herbert             
      ''',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ]));
  }
}
