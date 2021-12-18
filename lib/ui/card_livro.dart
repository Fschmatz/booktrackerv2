import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livro_dao.dart';
import 'package:booktrackerv2/pages/pg_update_livro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_animator/flutter_animator.dart';

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
  final GlobalKey<InOutAnimationState> inOutAnimation =
      GlobalKey<InOutAnimationState>();

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
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
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
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: ListTile(
                      leading: Icon(Icons.bookmark_outline,
                          color: Theme.of(context).hintColor),
                      title: const Text(
                        "Marcar como para ler",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 0);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: ListTile(
                      leading: Icon(Icons.book_outlined,
                          color: Theme.of(context).hintColor),
                      title: const Text(
                        "Marcar como lendo",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 1);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: ListTile(
                      leading: Icon(Icons.done_outlined,
                          color: Theme.of(context).hintColor),
                      title: const Text(
                        "Marcar como lido",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 2);
                        inOutAnimation.currentState!.animateOut();

                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit_outlined,
                        color: Theme.of(context).hintColor),
                    title: const Text(
                      "Editar livro",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PgUpdateLivro(
                              livro: widget.livro,
                              refreshLista: widget.getLivrosState,
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    title: const Text(
                      "Deletar livro",
                      style: TextStyle(fontSize: 16),
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
      child: Text(
        "Sim",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
      ),
      onPressed: () {
        _deletar(widget.livro.id);
        inOutAnimation.currentState!.animateOut();
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.getLivrosState();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: const Text(
        "Confirmação ", //
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "\nDeletar livro ?",
        style: TextStyle(
          fontSize: 16,
        ),
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
    return InOutAnimation(
      key: inOutAnimation,
      inDefinition: FadeInAnimation(),
      outDefinition: FadeOutAnimation(),
      child: InkWell(
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
                              height: 122,
                              width: 87,
                              child: Card(
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
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
                                  widget.livro.capa!,
                                  height: 115,
                                  width: 80,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.medium,
                                  gaplessPlayback: true,
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
                                fontSize: 15,
                                color: Theme.of(context).hintColor),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Visibility(
                          visible: widget.livro.numPaginas != 0,
                          child: Text(
                            "Páginas: " + widget.livro.numPaginas.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).hintColor),
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
      ),
    );
  }
}
