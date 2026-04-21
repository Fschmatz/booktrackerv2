import 'package:async_redux/async_redux.dart';
import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/card_livro_grid.dart';
import 'package:booktrackerv2/widgets/card_livro_list.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';

class ListaLivroHome extends StatefulWidget {
  final SituacaoLivro situacaoLivro;

  ListaLivroHome({Key? key, required this.situacaoLivro}) : super(key: key);

  @override
  State<ListaLivroHome> createState() => _ListaLivroHomeState();
}

class _ListaLivroHomeState extends State<ListaLivroHome> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ({List<Livro> livros, bool useGrid})>(converter: (store) {
      return (
        livros: selectListLivroByPaginaAtual(widget.situacaoLivro),
        useGrid: selectParameterValueByKeyAsBoolean('useHomeGrid', defaultValue: false),
      );
    }, builder: (context, data) {
      return ListView(
        children: [
          data.useGrid
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: data.livros.length,
                  itemBuilder: (context, index) {
                    Livro livro = data.livros[index];

                    return CardLivroGrid(
                      key: ValueKey(livro.id),
                      livro: livro,
                    );
                  },
                )
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(
                    height: 8,
                  ),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.livros.length,
                  itemBuilder: (context, int index) {
                    Livro livro = data.livros[index];

                    return CardLivroList(
                      key: ValueKey(livro.id),
                      livro: livro,
                    );
                  },
                ),
          const SizedBox(
            height: 50,
          )
        ],
      );
    });
  }
}
