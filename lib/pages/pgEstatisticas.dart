import 'package:booktrackerv2/db/livroDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PgEstatisticas extends StatefulWidget {
  const PgEstatisticas({Key? key}) : super(key: key);

  @override
  _PgEstatisticasState createState() => _PgEstatisticasState();
}

class _PgEstatisticasState extends State<PgEstatisticas> {

  final dbLivro = LivroDao.instance;
  bool loading = true;

  int livrosLendo = 0;
  int livrosParaLer = 0;
  int livrosLidos = 0;
  int paginasLendo = 0;
  int paginasParaLer = 0;
  int paginasLidos = 0;

  @override
  void initState() {
    getAllLivros();
    super.initState();
  }

  Future<void> getAllLivros() async {
    var resp = await dbLivro.queryAllLivros(1);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    Color accent = Theme.of(context).accentColor;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: loading ?  Center(
        child: CircularProgressIndicator(color: Theme.of(context).accentColor,),
      ) : ListView(
        children: [
          cardEstatisticas('Quantidade de Livros', 3, 2 , 1,accent),
          const SizedBox(
            height: 10,
          ),
          cardEstatisticas('Quantidade de Páginas', 4, 4 , 4, accent),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

Widget cardEstatisticas(String tituloCard,int valorLendo, int valorParaLer, int valorLidos, Color accent){

  TextStyle styleTrailing = TextStyle(fontSize: 16);

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    elevation: 1,
    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    child: Column(
      children: [
        ListTile(
          title: Text(tituloCard,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,color: accent ),),
        ),
        ListTile(
          leading: Icon(Icons.book_outlined),
          title: Text('Lendo'),
          trailing: Text(valorLendo.toString(),style: styleTrailing),
        ),
        ListTile(
          leading: Icon(Icons.bookmark_outline),
          title: Text('Para Ler'),
          trailing: Text(valorParaLer.toString(),style: styleTrailing),
        ),
        ListTile(
          leading: Icon(Icons.done_outlined),
          title: Text('Lidos'),
          trailing: Text(valorLidos.toString(),style: styleTrailing),
        ),
        ListTile(
          leading: SizedBox.shrink(),
          title: Text('Total'),
          trailing: Text((valorLidos + valorParaLer + valorLendo).toString(),style: styleTrailing),
        ),
      ],
    ),
  );
}
