import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/enum/situacao_livro.dart';
import 'package:booktrackerv2/pages/editar_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

class ModalOpcoesLivro extends StatelessWidget {
  final Livro livro;
  final bool isGrid;

  const ModalOpcoesLivro({
    Key? key,
    required this.livro,
    required this.isGrid,
  }) : super(key: key);

  static void show(BuildContext context, Livro livro, {bool isGrid = false}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      builder: (BuildContext bottomSheetContext) {
        return ModalOpcoesLivro(livro: livro, isGrid: isGrid);
      },
    );
  }

  void _deletar() async {
    await LivroService().deletar(livro);
  }

  void _executarMudarEstado(SituacaoLivro situacaoLivro, BuildContext context) async {
    await LivroService().mudarSituacao(livro, situacaoLivro);
    Navigator.of(context).pop();
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
    final TextStyle styleNome = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    final TextStyle styleLeading = const TextStyle(fontSize: 16);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text(
                livro.nome,
                textAlign: TextAlign.center,
                style: styleNome,
              ),
            ),
            if (isGrid) ...[
              if (livro.autor != null && livro.autor!.isNotEmpty)
                ListTile(
                  leading: Text(
                    "Autor:",
                    style: styleLeading,
                  ),
                  title: Text(
                    "${livro.autor!} ",
                  ),
                ),
              if (livro.numPaginas != null && livro.numPaginas != 0)
                ListTile(
                  leading: Text(
                    "Nº de Páginas:",
                    style: styleLeading,
                  ),
                  title: Text(
                    "${livro.numPaginas}",
                  ),
                ),
            ],
            const Divider(),
            Visibility(
              visible: livro.situacaoLivro != 0,
              child: ListTile(
                leading: const Icon(Icons.book_outlined),
                title: const Text(
                  "Marcar como lendo",
                ),
                onTap: () {
                  _executarMudarEstado(SituacaoLivro.LENDO, context);
                },
              ),
            ),
            Visibility(
              visible: livro.situacaoLivro != 1,
              child: ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text(
                  "Marcar como para ler",
                ),
                onTap: () {
                  _executarMudarEstado(SituacaoLivro.PARA_LER, context);
                },
              ),
            ),
            Visibility(
              visible: livro.situacaoLivro != 2,
              child: ListTile(
                leading: const Icon(Icons.task_outlined),
                title: const Text(
                  "Marcar como lido",
                ),
                onTap: () {
                  _executarMudarEstado(SituacaoLivro.LIDO, context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Editar"),
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
            ListTile(
              leading: const Icon(Icons.delete_outline_outlined),
              title: const Text("Deletar"),
              onTap: () {
                Navigator.of(context).pop();
                _showAlertDialogOkDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
