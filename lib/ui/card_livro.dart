import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/editar_livro.dart';
import 'package:flutter/material.dart';

class CardLivro extends StatefulWidget {
  @override
  _CardLivroState createState() => _CardLivroState();

  Livro livro;
  int paginaAtual;
  Function() getLivrosState;

  CardLivro({Key? key, required this.livro, required this.getLivrosState, required this.paginaAtual}) : super(key: key);
}

class _CardLivroState extends State<CardLivro> {
  BorderRadius capaBorder = BorderRadius.circular(12);
  double capaHeight = 130;
  double capaWidth = 105;

  void _deletar(int id) async {
    final dbLivro = LivroDao.instance;
    await dbLivro.delete(id);
  }

  void _mudarEstado(int id, int lido) async {
    final dbLivro = LivroDao.instance;
    Map<String, dynamic> row = {
      LivroDao.columnIdLivro: id,
      LivroDao.columnLido: lido,
    };
    await dbLivro.update(row);
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
                    visible: widget.paginaAtual != 0,
                    child: ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text(
                        "Marcar como lendo",
                      ),
                      onTap: () {
                        _mudarEstado(widget.livro.id, 0);
                        widget.getLivrosState();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: const Text(
                        "Marcar como para ler",
                      ),
                      onTap: () {
                        _mudarEstado(widget.livro.id, 1);
                        widget.getLivrosState();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: ListTile(
                      leading: const Icon(Icons.task_outlined),
                      title: const Text(
                        "Marcar como lido",
                      ),
                      onTap: () {
                        _mudarEstado(widget.livro.id, 2);
                        widget.getLivrosState();
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
                              refreshLista: widget.getLivrosState,
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
            "Deletar livro ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Sim",
              ),
              onPressed: () {
                _deletar(widget.livro.id);
                widget.getLivrosState();
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

    return InkWell(
      onTap: openBottomMenuBookSettings,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: widget.livro.capa == null
                        ? SizedBox(
                            height: capaHeight,
                            width: capaWidth,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: capaBorder,
                              ),
                              child: Icon(
                                Icons.book,
                                size: 35,
                                color: theme.hintColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: capaHeight,
                            width: capaWidth,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: capaBorder,
                              ),
                              child: ClipRRect(
                                borderRadius: capaBorder,
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.livro.nome,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Visibility(
                          visible: widget.livro.autor!.isNotEmpty,
                          child: Text(
                            widget.livro.autor!,
                            style: TextStyle(fontSize: 14, color: theme.hintColor),
                          ),
                        ),
                        Visibility(
                          visible: widget.livro.numPaginas != 0,
                          child: Text(
                            widget.livro.numPaginas.toString() + " Páginas",
                            style: TextStyle(fontSize: 14, color: theme.hintColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
