import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/pages/editar_livro.dart';
import 'package:booktrackerv2/service/livro_service.dart';
import 'package:flutter/material.dart';

import '../enum/situacao_livro.dart';

class CardLivro extends StatefulWidget {
  final Livro livro;

  CardLivro({Key? key, required this.livro}) : super(key: key);

  @override
  State<CardLivro> createState() => _CardLivroState();
}

class _CardLivroState extends State<CardLivro> {
  final BorderRadius _capaBorder = BorderRadius.circular(12);
  final double _capaHeight = 140;
  final double _capaWidth = 110;
  final TextStyle _styleNome = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  final TextStyle _styleAutorPaginas = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  void _deletar() async {
    await LivroService().deletar(widget.livro);
  }

  void _mudarEstado(SituacaoLivro situacaoLivro) async {
    await LivroService().mudarSituacao(widget.livro, situacaoLivro);
  }

  void openBottomMenuBookSettings() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      widget.livro.nome,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: widget.livro.situacaoLivro != 0,
                    child: ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text(
                        "Marcar como lendo",
                      ),
                      onTap: () {
                        _mudarEstado(SituacaoLivro.LENDO);

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.livro.situacaoLivro != 1,
                    child: ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: const Text(
                        "Marcar como para ler",
                      ),
                      onTap: () {
                        _mudarEstado(SituacaoLivro.PARA_LER);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.livro.situacaoLivro != 2,
                    child: ListTile(
                      leading: const Icon(Icons.task_outlined),
                      title: const Text(
                        "Marcar como lido",
                      ),
                      onTap: () {
                        _mudarEstado(SituacaoLivro.LIDO);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Editar",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditarLivro(
                              livro: widget.livro,
                            ),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Deletar",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAlertDialogOkDelete(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmação",
          ),
          content: const Text(
            "Deletar livro?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Sim",
              ),
              onPressed: () {
                _deletar();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      margin: EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: openBottomMenuBookSettings,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: widget.livro.capa == null
                    ? SizedBox(
                        height: _capaHeight,
                        width: _capaWidth,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: _capaBorder,
                          ),
                          child: Icon(
                            Icons.book,
                            size: 35,
                            color: theme.hintColor,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: _capaHeight,
                        width: _capaWidth,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: _capaBorder,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ClipRRect(
                            borderRadius: _capaBorder,
                            child: Image.memory(
                              widget.livro.capa!,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.medium,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.livro.nome,
                      style: _styleNome,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Visibility(
                      visible: widget.livro.autor!.isNotEmpty,
                      child: Text(
                        widget.livro.autor!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _styleAutorPaginas.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.livro.numPaginas != 0,
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        widget.livro.numPaginas.toString() + " Páginas",
                        style: _styleAutorPaginas.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
