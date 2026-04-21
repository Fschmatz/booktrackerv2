import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/widgets/capa_livro.dart';
import 'package:booktrackerv2/widgets/modal_opcoes_livro.dart';
import 'package:flutter/material.dart';

class CardLivroGrid extends StatelessWidget {
  final Livro livro;
  final VoidCallback? onTap;

  const CardLivroGrid({
    Key? key,
    required this.livro,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final BorderRadius cardBorder = BorderRadius.circular(12);

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: cardBorder,
        side: BorderSide(color: theme.colorScheme.surfaceContainerHighest, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => ModalOpcoesLivro.show(context, livro, isGrid: true),
        child: CapaLivro(
          capa: livro.capa,
          borderRadius: cardBorder,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
