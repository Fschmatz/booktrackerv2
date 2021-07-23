import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livroDao.dart';
import 'package:booktrackerv2/pages/pgUpdateLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_animator/flutter_animator.dart';

class CardLivro extends StatefulWidget {
  @override
  _CardLivroState createState() => _CardLivroState();

  Livro livro;
  int paginaAtual;
  Function() refreshLista;

  CardLivro({Key? key,required this.livro, required this.refreshLista,required this.paginaAtual})
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    title: Text(
                      widget.livro.nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: ListTile(
                      leading:
                          Icon(Icons.book, color: Theme.of(context).hintColor),
                      title: Text(
                        "Marcar como Para Ler",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 0);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.refreshLista();
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
                      leading:
                          Icon(Icons.book, color: Theme.of(context).hintColor),
                      title: Text(
                        "Marcar como Lendo",
                        style: TextStyle(fontSize: 17),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 1);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.refreshLista();
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
                      leading:
                          Icon(Icons.book, color: Theme.of(context).hintColor),
                      title: Text(
                        "Marcar como Lido",
                        style: TextStyle(fontSize: 17),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 2);
                        inOutAnimation.currentState!.animateOut();

                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.refreshLista();
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
                    title: Text(
                      "Editar Livro",
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PgUpdateLivro(
                              livro: widget.livro,
                              refreshLista: widget.refreshLista,
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    title: Text(
                      "Deletar Livro",
                      style: TextStyle(fontSize: 17),
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        _deletar(widget.livro.id);
        inOutAnimation.currentState!.animateOut();
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.refreshLista();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Confirmação ", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "\nDeletar Livro ?",
        style: TextStyle(
          fontSize: 18,
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

    //print('capa pg '+widget.paginaAtual.toString()+' ->      '+widget.livro.capa.toString());
    return InOutAnimation(
      key: inOutAnimation,
      inDefinition: FadeInAnimation(),
      outDefinition: FadeOutAnimation(),
      child: InkWell(
        onTap: openBottomMenuBookSettings,
        child: Container(
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
                              ? Container(
                                height: 112,
                                width: 77,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.book,
                                    size: 35,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              )
                              : Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.memory(
                                      widget.livro.capa!,
                                      height: 105,
                                      width: 70,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          //alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.livro.nome,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
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
                              SizedBox(
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
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
