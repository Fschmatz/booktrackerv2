import 'dart:io';
import 'package:booktrackerv2/db/livroDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class AddLivro extends StatefulWidget {
  @override
  _AddLivroState createState() => _AddLivroState();

  bool tema;
  Function() refreshLista;

  AddLivro({Key key, this.refreshLista, this.tema}) : super(key: key);
}

class _AddLivroState extends State<AddLivro> {
  final dbLivro = LivroDao.instance;

  TextEditingController customControllerNomeLivro = TextEditingController();
  TextEditingController customControllerPaginas = TextEditingController();
  TextEditingController customControllerAutor = TextEditingController();
  FocusNode inputFieldNode;

  //IMAGEM
  final imagePicker = ImagePicker();
  File capa;

  pickGallery() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File compressedFile = await FlutterNativeImage.compressImage(pickedFile.path, quality: 95,
        targetWidth: 325, targetHeight: 475);

    if (compressedFile == null) {
      return;
    } else {
      setState(() {
        capa = compressedFile;
      });
    }
  }


  //AUTOR E PAGINAS PODE SER NULO
  void _salvarLivro() async {

    Map<String, dynamic> row = {
      LivroDao.columnNome: customControllerNomeLivro.text,
      LivroDao.columnNumPaginas: customControllerPaginas.text.isEmpty
          ? 0
          : int.parse(customControllerPaginas.text),
      LivroDao.columnAutor: customControllerAutor.text,
      LivroDao.columnLido: 0, //sempre 0, = não lido
      LivroDao.columnCapa :  capa == null ?  null : capa.readAsBytesSync(),
    };
    final id = await dbLivro.insert(row);
    print('id inserido = $id');
  }

  //CHECK ERROR NULL
  String checkProblemas() {
    String erros = "";
    if (customControllerNomeLivro.text.isEmpty) {
      erros += "Insira um nome\n";
    }
    if (customControllerNomeLivro.text.length > 50) {
      erros += "Nome muito extenso\n";
    }
    if (customControllerAutor.text.length > 30) {
      erros += "Autor muito extenso\n";
    }
    if (customControllerPaginas.text.length > 5) {
      erros += "Páginas muito extenso\n";
    }
    return erros;
  }

  showAlertDialogErros(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Erro",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        checkProblemas(),
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
  _showPopupMenuRemoverCapa() async {
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
            child: Text("Remover Capa")
        ),
      ],
      elevation: 2.0,
    ).then((value) => {
      if (value == 1)
        {
          setState(() {
            capa = null;
          })
        }
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Adicionar Livro'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5,
            ),

            TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 50,
              maxLengthEnforced: true,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerNomeLivro,
              autofocus: true,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.article),
                  hintText: "Nome do Livro",
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0))),
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 10,
            ),

            TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    // RegExp(r'^(\d+)?\.?\d{0,2}'))
                    RegExp(r'^(\d+)?\d{0,2}'))
              ],
              minLines: 1,
              maxLines: 2,
              maxLength: 5,
              maxLengthEnforced: true,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              controller: customControllerPaginas,
              autofocus: true,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.book),
                  hintText: "Nº de Páginas",
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0))),
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 10,
            ),

            //CATEGORIA
            TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 30,
              maxLengthEnforced: true,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerAutor,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.contact_page_outlined,
                    size: 28,
                  ),
                  hintText: "Autor",
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(8.0))),
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 10,
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 130, 0),
              child: Card(
                color: Theme.of(context).canvasColor,
                margin: EdgeInsets.all(0),
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

                    onTap: pickGallery,
                    onTapDown: _storePosition,
                    onLongPress:  _showPopupMenuRemoverCapa,

                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 3, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                              color: widget.tema
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
                              width: 1.2,
                            ),
                          ),
                          elevation: 0,
                          child: capa == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  width: 60,
                                  height: 90,
                                  child: Icon(
                                    Icons.image,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.file(
                                    capa,
                                    width: 60,
                                    height: 90,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        Text("Adicionar Capa", style: TextStyle(fontSize: 18),),

                      ]),
                    ),
                  )),
            ),

            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: () {
            if (checkProblemas().isEmpty) {
              _salvarLivro();
              widget.refreshLista();
              Navigator.of(context).pop();
            } else {
              showAlertDialogErros(context);
            }
          },
          child: Icon(
            Icons.save_outlined,
            color: Colors.white,
          ),
          // elevation: 5.0,
        ),
      ),
    );
  }
}
