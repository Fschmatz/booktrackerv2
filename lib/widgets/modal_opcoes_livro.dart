import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/pages/editar_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:booktrackerv2/widgets/capa_livro.dart';
import 'package:flutter/material.dart';

import '../util/toast_utils.dart';
import 'modal_info_tile.dart';

class ModalOpcoesLivro extends StatelessWidget {
  final Livro livro;
  final bool isGrid;
  final TextStyle styleNomeLivro = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  const ModalOpcoesLivro({
    Key? key,
    required this.livro,
    required this.isGrid,
  }) : super(key: key);

  static void show(BuildContext context, Livro livro, {bool isGrid = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      builder: (BuildContext bottomSheetContext) {
        return ModalOpcoesLivro(livro: livro, isGrid: isGrid);
      },
    );
  }

  void _deletar() async {
    await LivroService().deletar(livro);
    ToastUtils.show("Livro removido com sucesso!");
  }

  void _showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Deletar livro?"),
          actions: [
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                _deletar();
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CapaLivro(
                      capa: livro.capa,
                      width: 65,
                      height: 95,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            livro.nome,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (livro.autor != null && livro.autor!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              livro.autor!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isGrid || livro.criadoEm != null)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        if (isGrid && livro.numPaginas != null && livro.numPaginas != 0)
                          ModalInfoTile(label: "Nº de Páginas:", value: livro.numPaginas.toString()),
                        if (livro.criadoEm != null) ModalInfoTile(label: "Adicionado em:", value: livro.criadoEm!),
                        if (livro.finalizadoEm != null && livro.isFinalizado()) ModalInfoTile(label: "Finalizado em:", value: livro.finalizadoEm!),
                      ],
                    ),
                  ),
                ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text("Editar"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditarLivro(livro: livro),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.delete_outline_outlined),
                      title: Text("Deletar"),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showAlertDialogOkDelete(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
