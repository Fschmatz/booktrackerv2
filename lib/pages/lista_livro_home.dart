import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/ui/card_livro.dart';
import 'package:flutter/material.dart';

import '../service/livro_service.dart';

class ListaLivroHome extends StatefulWidget {
  int bookState;

  ListaLivroHome({Key? key, required this.bookState}) : super(key: key);

  @override
  _ListaLivroHomeState createState() => _ListaLivroHomeState();
}

class _ListaLivroHomeState extends State<ListaLivroHome> with AutomaticKeepAliveClientMixin<ListaLivroHome> {
  @override
  bool get wantKeepAlive => true;

  List<Livro> listaLivros = [];
  final dbLivro = LivroDao.instance;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getLivrosState();
  }

  void getLivrosState() async {
    listaLivros = await LivroService().queryAllByStateAndConvertToList(widget.bookState);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return (loading)
        ? const Center(child: SizedBox.shrink())
        : (listaLivros.isEmpty)
            ? const Center(
                child: Text(
                'Está um pouco vazio por aqui!',
                style: TextStyle(fontSize: 16),
              ))
            : ListView(
                children: [
                  ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(
                      height: 4,
                    ),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listaLivros.length,
                    itemBuilder: (context, int index) {
                      return CardLivro(
                        key: UniqueKey(),
                        livro: listaLivros[index],
                        getLivrosState: getLivrosState,
                        paginaAtual: widget.bookState,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              );
  }
}
