import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/pg_editar_livro.dart';
import 'package:flutter/material.dart';

class CardLivro extends StatefulWidget {
  @override
  _CardLivroState createState() => _CardLivroState();

  Livro livro;
  int paginaAtual;
  Function() getLivrosState;

  CardLivro(
      {Key? key,
      required this.livro,
      required this.getLivrosState,
      required this.paginaAtual})
      : super(key: key);
}

class _CardLivroState extends State<CardLivro> {
  void _deletar(int id) async {
    final dbLivro = LivroDao.instance;
    final deletado = await dbLivro.delete(id);
  }

  void _mudarEstado(int id, int lido) async {
    final dbLivro = LivroDao.instance;
    Map<String, dynamic> row = {
      LivroDao.columnIdLivro: id,
      LivroDao.columnLido: lido,
    };
    final atualizar = await dbLivro.update(row);
  }

  void openBottomMenuBookSettings() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    title: Text(
                      widget.livro.nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text(
                        "Marcar como lendo",
                      ),
                      onTap: () {
                        _mudarEstado(widget.livro.id, 1);
                        widget.getLivrosState();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: const Text(
                        "Marcar como para ler",
                      ),
                      onTap: () {
                        _mudarEstado(widget.livro.id, 0);
                        widget.getLivrosState();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: ListTile(
                      leading: const Icon(Icons.done_outlined),
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
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Editar livro",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PgEditarLivro(
                              livro: widget.livro,
                              refreshLista: widget.getLivrosState,
                            ),
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Deletar livro",
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
    Widget okButton = TextButton(
      child: const Text(
        "Sim",
      ),
      onPressed: () {
        _deletar(widget.livro.id);
        widget.getLivrosState();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Confirmação ",
      ),
      content: const Text(
        "Deletar livro ?",
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openBottomMenuBookSettings,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
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
                            height: 116,
                            width: 83,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.book,
                                size: 35,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 116,
                            width: 83,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
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
                      const SizedBox(
                        height: 7,
                      ),
                      Visibility(
                        visible: widget.livro.autor!.isNotEmpty,
                        child: Text(
                          widget.livro.autor!,
                          style: TextStyle(
                              fontSize: 16, color: Theme.of(context).hintColor),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Visibility(
                        visible: widget.livro.numPaginas != 0,
                        child: Text(
                          widget.livro.numPaginas.toString() + " Páginas",
                          style: TextStyle(
                              fontSize: 16, color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
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
