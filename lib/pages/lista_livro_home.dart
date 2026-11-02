import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/card_livro_grid.dart';
import 'package:booktrackerv2/widgets/card_livro_list.dart';
import 'package:booktrackerv2/widgets/card_resumo.dart';
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
    final showCardResumo =
        context.select((state) => selectParameterValueByKeyAsBoolean(state, AppConstants.showResumePageCardAppParameter, defaultValue: false));
    final gridSize = context.select((state) => selectParameterValueByKeyAsInt(state, AppConstants.gridSizeAppParameter, defaultValue: 3));
    final double gridAspectRatio = AppConstants.mapGridSizeOptions[gridSize] ?? 0.66;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (showCardResumo) ...[
          CardResumo(
            livros: livros,
            useGrid: useGrid,
          )
        ],
        useGrid
            ? GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  childAspectRatio: gridAspectRatio,
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
