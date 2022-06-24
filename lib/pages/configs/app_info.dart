import 'package:booktrackerv2/util/app_details.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key}) : super(key: key);

  _launchGithub() {
    launchUrl(
      Uri.parse(AppDetails.repositoryLink),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Informações"),
        ),
        body: ListView(children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.yellow[600],
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(AppDetails.nomeApp + " " + AppDetails.versaoApp,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          const SizedBox(height: 15),
          ListTile(
            title: Text("Dev",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              "MARTELADO E REFEITO DO ZERO: 1 X POR ENQUANTO !!!\n( Por causa de um problema grave do SDK, culpa do Flutter! )\nVamos que Vamos, denovo!!!",
            ),
          ),
          const ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text(
              "Aplicativo criado utilizando o Flutter e a linguagem Dart, usado para testes e aprendizado.",
            ),
          ),
          ListTile(
            title: Text("Código Fonte",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            onTap: () {
              _launchGithub();
            },
            leading: const Icon(Icons.open_in_new_outlined),
            title: const Text("Ver no Github",
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue)),
          ),
          ListTile(
            title: Text("Quote",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          const ListTile(
            leading: Icon(Icons.messenger_outline),
            title: Text(
              ''' 
“The capacity to learn is a gift; 
the ability to learn is a skill; 
the willingness to learn is a choice.” 
– Brian Herbert             
      ''',
            ),
          ),
        ]));
  }
}
