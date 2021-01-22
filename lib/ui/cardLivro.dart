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
  bool tema;
  Function() refreshLista;

  CardLivro({Key key, this.livro, this.tema, this.refreshLista})
      : super(key: key);
}

class _CardLivroState extends State<CardLivro> {


  @override
  void initState() {
    super.initState();
  }

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

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = FlatButton(
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
        "Confirmação ",//
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

  var _tapPosition;

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      color: widget.tema ? Color(0xFF2A2A2B) : Color(0xFFE9E9EF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40),
          Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
          value: 1,
          child: widget.livro.lido == 0
              ? Text("Marcar como Terminado")
              : Text("Marcar como Lendo"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Editar Livro"),
          //child: Text("Marcar como Não Lido"),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Deletar Livro"),
        ),
      ],
      elevation: 2.0,
    ).then((value) => {
          if (value == 1)
            {
              if (widget.livro.lido == 0)
                {
                  _marcarLido(widget.livro.id, 1),
                  widget.refreshLista(),
                }
              else
                {
                  _marcarLido(widget.livro.id, 0),
                  widget.refreshLista(),
                }
            }
          else if (value == 2)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => UpdateLivro(
                      livro: widget.livro,
                      refreshLista: widget.refreshLista,
                      tema: widget.tema,
                    ),
                    fullscreenDialog: true,
                  ))
            }
          else if (value == 3)
            {
              //_deletar(widget.livro.id),
              //widget.refreshLista(),
              showAlertDialogOkDelete(context),
            }
        });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: widget.tema
              ? Colors.black.withOpacity(0.5)
              : Colors.grey.withOpacity(0.5),
          width: 1.2,
        ),
      ),
      elevation: 0,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTapDown: _storePosition,
        onLongPress: _showPopupMenu,
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

                      child: widget.livro.capa == null ?
                      Center(
                        widthFactor: 1.5,
                        child: Icon(
                          Icons.book,
                          size: 40,
                          color: Theme.of(context).hintColor,// Color(0xFFB4A1E0),//Colors.redAccent[100]
                        ),
                      )
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.memory(
                          widget.livro.capa,
                          width: 60,
                          height: 90,
                          fit: BoxFit.fill,
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
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Visibility(
                            visible: widget.livro.numPaginas != 0,
                            child: Text(
                              "Páginas: " + widget.livro.numPaginas.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Visibility(
                            visible: widget.livro.autor.isNotEmpty,
                            child: Text(
                              widget.livro.autor,
                              style: TextStyle(
                                  fontSize: 16,
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
