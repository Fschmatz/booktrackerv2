import 'package:booktrackerv2/class/livro.dart';
import 'package:booktrackerv2/db/livroDao.dart';
import 'package:booktrackerv2/ui/updateLivro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CardLivro extends StatefulWidget {
  @override
  _CardLivroState createState() => _CardLivroState();

  Livro livro;
  int paginaAtual;
  Function() refreshLista;

  CardLivro({Key key, this.livro, this.refreshLista, this.paginaAtual})
      : super(key: key);
}

class _CardLivroState extends State<CardLivro> {
  void _deletar(int id) async {
    final dbLivro = LivroDao.instance;
    final deletado = await dbLivro.delete(id);
  }

  void _marcarLido(int id, int lido) async {
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
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.fromLTRB(50, 15, 50, 25),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      title: Text(
                        widget.livro.nome,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
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

                        _marcarLido(widget.livro.id, 0);
                        widget.refreshLista();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: ListTile(
                      leading:
                          Icon(Icons.book, color: Theme.of(context).hintColor),
                      title: Text(
                        "Marcar como Lendo",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();

                        _marcarLido(widget.livro.id, 1);
                        widget.refreshLista();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: ListTile(
                      leading:
                          Icon(Icons.book, color: Theme.of(context).hintColor),
                      title: Text(
                        "Marcar como Lido",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();

                        _marcarLido(widget.livro.id, 2);
                        widget.refreshLista();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit_outlined,
                        color: Theme.of(context).hintColor),
                    title: Text(
                      "Editar Livro",
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => UpdateLivro(
                              livro: widget.livro,
                              refreshLista: widget.refreshLista,
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    //trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text(
                      "Deletar Livro",
                      style: TextStyle(fontSize: 18),
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
        widget.refreshLista();
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
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[600].withOpacity(0.3),
          width: 0.8,
        ),
      ),
      elevation: 0,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onTap: openBottomMenuBookSettings,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: widget.livro.capa == null
                          ? Center(
                              widthFactor: 1.5,
                              child: Icon(
                                Icons.book,
                                size: 42,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : Card(
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: Colors.grey[600].withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.memory(
                                  widget.livro.capa,
                                  width: 70,
                                  height: 105,
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
                              fontSize: 16.5,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Visibility(
                            visible: widget.livro.autor.isNotEmpty,
                            child: Text(
                              widget.livro.autor,
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
        ),
      ),
    ));
  }
}
