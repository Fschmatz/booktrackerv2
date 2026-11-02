import 'package:flutter/material.dart';

import '../class/livro.dart';

class CardResumo extends StatelessWidget {
  final List<Livro> livros;
  final bool useGrid;

  CardResumo({Key? key, required this.livros, required this.useGrid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.primaryContainer;
    final textColor = theme.colorScheme.onPrimaryContainer;
    final textStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: textColor);
    final int totalPaginas = livros.fold<int>(0, (previousValue, element) => previousValue + (element.numPaginas ?? 0));
    final int totalLivros = livros.length;

    return Card(
      margin: EdgeInsetsGeometry.fromLTRB(16, 0, 16, (useGrid ? 10 : 14)),
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Livros: ${totalLivros}",
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Páginas: ${totalPaginas}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ],
          )),
    );
  }
}
