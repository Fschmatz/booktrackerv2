import 'package:flutter/material.dart';
import '../util/versaoNomeChangelog.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: Text("Sobre"),
          centerTitle: true,
          elevation: 0.0,
        ),

        body: Container(
          padding: EdgeInsets.fromLTRB(6,0,6,5),
          child: ListView(
              children: <Widget>[

                SizedBox(height: 20),
                Text(versaoNomeChangelog.nomeApp+" " + versaoNomeChangelog.versaoApp,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 25),

                CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFF867aa3),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                ),

                Text( '''                     
                
MARTELADO E REFEITO DO ZERO: 
1 X POR ENQUANTO !!!
(Por causa de um problema grave do 
SDK, culpa do Flutter!)
(Vamos que Vamos, denovo!!!)        
      ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),


                Text( '''                     
                                
 Aplicativo criado utilizando 
o Flutter e a linguagem Dart,
usado para testes e aprendizado.       
                     
 Este aplicativo um dia terá 
seu código disponibilizado 
gratuitamente no GitHub e 
talvez adicionado ao F-Droid.             
      ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    //fontWeight: FontWeight.bold
                  ),
                ),

                Text( ''' 
                
                      
“The capacity to learn is a gift; 
the ability to learn is a skill; 
the willingness to learn is a choice.” 
– Brian Herbert             
      ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ]),
        )
    );

  }
}

