import 'package:booktrackerv2/db/livro_dao.dart';
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

  int? livrosLendo = 0;
  int? livrosParaLer = 0;
  int? livrosLidos = 0;
  int? paginasLendo = 0;
  int? paginasParaLer = 0;
  int? paginasLidos = 0;
  int? quantAutores = 0;

  @override
  void initState() {
    getContagemLivrosEstado().then((v) => getContagemPaginasEstado());
    super.initState();
  }

  Future<void> getContagemLivrosEstado() async {
    var respLendo = await dbLivro.contagemLivrosEstado(1);
    var respParaLer = await dbLivro.contagemLivrosEstado(0);
    var respLidos = await dbLivro.contagemLivrosEstado(2);
    setState(() {
      livrosLendo = respLendo ?? 0;
      livrosParaLer = respParaLer ?? 0;
      livrosLidos = respLidos ?? 0;
    });
  }

  Future<void> getContagemPaginasEstado() async {
    var respLendo = await dbLivro.contagemPaginasEstado(1);
    var respParaLer = await dbLivro.contagemPaginasEstado(0);
    var respLidos = await dbLivro.contagemPaginasEstado(2);
    var respAutores = await dbLivro.contagemAutores();

    setState(() {
      paginasLendo = respLendo ?? 0;
      paginasParaLer = respParaLer ?? 0;
      paginasLidos = respLidos ?? 0;
      quantAutores = respAutores ?? 0;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    Color accent = Theme.of(context).accentColor;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: loading ?  Center(
        child: CircularProgressIndicator(color: Theme.of(context).accentColor,),
      ) : ListView(
        children: [
          cardEstatisticas('Livros', livrosLendo, livrosParaLer , livrosLidos,accent),
         const Divider(),
          cardEstatisticas('Páginas', paginasLendo, paginasParaLer , paginasLidos, accent),
          const Divider(),
          cardAutores('Geral', quantAutores, accent),
          const SizedBox(height: 75,),
        ],
      ),
    );
  }
}

Widget cardEstatisticas(String tituloCard,int? valorLendo, int? valorParaLer, int? valorLidos, Color accent){

  TextStyle styleTrailing = const TextStyle(fontSize: 16);
  int soma = (valorLidos! + valorParaLer!  + valorLendo! );

  return Column(
    children: [
      ListTile(
        title: Text(tituloCard,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accent)),
      ),
      ListTile(
        leading: const Icon(Icons.book_outlined),
        title: const Text('Lendo'),
        trailing: Text(valorLendo.toString(),style: styleTrailing),
      ),
      ListTile(
        leading: const Icon(Icons.bookmark_outline),
        title: const Text('Para Ler'),
        trailing: Text(valorParaLer.toString(),style: styleTrailing),
      ),
      ListTile(
        leading: const Icon(Icons.done_outlined),
        title: const Text('Lidos'),
        trailing: Text(valorLidos.toString(),style: styleTrailing),
      ),
      ListTile(
        leading: const SizedBox.shrink(),
        title: const Text('Total'),
        trailing: Text(soma.toString(),style: styleTrailing,),
      ),
    ],
  );
}

Widget cardAutores(String tituloCard,int? valor, Color accent){

  TextStyle styleTrailing = const TextStyle(fontSize: 16);

  //BANCO CONTA O VALOR VAZIO, QUE ESTÁ CONFIGURADO PARA O LIVRO SEM AUTOR
  int valorCalculado = valor == 0 ? 0 : (valor! - 1);

  return Column(
    children: [
      ListTile(
        title: Text(tituloCard,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accent)),
      ),
      ListTile(
        leading: const Icon(Icons.person_outline_outlined),
        title: const Text('Autores'),
        trailing: Text(valorCalculado.toString(),style: styleTrailing),
      ),

    ],
  );
}
