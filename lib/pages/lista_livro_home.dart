import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/card_livro_grid.dart';
import 'package:booktrackerv2/widgets/card_livro_list.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';
import '../redux/build_context_extension.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';

class ListaLivroHome extends StatefulWidget {
  final SituacaoLivro situacaoLivro;

  ListaLivroHome({Key? key, required this.situacaoLivro}) : super(key: key);

  @override
  State<ListaLivroHome> createState() => _ListaLivroHomeState();
}

class _ListaLivroHomeState extends State<ListaLivroHome> {
  @override
  Widget build(BuildContext context) {
    final livros = context.select((state) => selectListLivroByPaginaAtual(state, widget.situacaoLivro));
    final useGrid = context.select((state) => selectParameterValueByKeyAsBoolean(state, AppConstants.useHomeGridAppParameter, defaultValue: false));

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        useGrid
            ? GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.66,
                ),
                itemCount: livros.length,
                itemBuilder: (context, index) {
                  Livro livro = livros[index];

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
                itemCount: livros.length,
                itemBuilder: (context, int index) {
                  Livro livro = livros[index];

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
  }
}
