import 'dart:io';
import 'package:booktrackerv2/db/livroDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class PgNovoLivro extends StatefulWidget {
  @override
  _PgNovoLivroState createState() => _PgNovoLivroState();

  int paginaAtual;

  //Function() refreshLista;

  PgNovoLivro({Key? key, required this.paginaAtual}) : super(key: key);
}

class _PgNovoLivroState extends State<PgNovoLivro> {
  final dbLivro = LivroDao.instance;

  TextEditingController customControllerNomeLivro = TextEditingController();
  TextEditingController customControllerPaginas = TextEditingController();
  TextEditingController customControllerAutor = TextEditingController();
  late FocusNode inputFieldNode;

  //IMAGEM
  final imagePicker = ImagePicker();
  File? capa;

  pickGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    File? compressedFile = await FlutterNativeImage.compressImage(
        pickedFile!.path,
        quality: 95,
        targetWidth: 325,
        targetHeight: 475);

    if (compressedFile == null) {
      return 0;
    } else {
      setState(() {
        capa = compressedFile;
      });
    }
  }

  //AUTOR, PAGINAS E CAPA PODEM SER NULO
  void _salvarLivro() async {
    Map<String, dynamic> row = {
      LivroDao.columnNome: customControllerNomeLivro.text,
      LivroDao.columnNumPaginas: customControllerPaginas.text.isEmpty
          ? 0
          : int.parse(customControllerPaginas.text),
      LivroDao.columnAutor: customControllerAutor.text,
      LivroDao.columnLido: widget.paginaAtual,
      LivroDao.columnCapa: capa == null ? null : capa!.readAsBytesSync(),
    };
    final id = await dbLivro.insert(row);
  }

  //CHECK ERROR NULL
  String checkProblemas() {
    String erros = "";
    if (customControllerNomeLivro.text.isEmpty) {
      erros += "Insira um nome\n";
    }
    return erros;
  }

  showAlertDialogErros(BuildContext context) {
    Widget okButton = TextButton(
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

  void removerCapa() {
    setState(() {
      capa = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Adicionar Livro'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              icon: Icon(Icons.save_outlined),
              tooltip: 'Salvar',
              onPressed: () {
                if (checkProblemas().isEmpty) {
                  _salvarLivro();
                  //widget.refreshLista();
                  Navigator.of(context).pop();
                } else {
                  showAlertDialogErros(context);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Nome".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(Icons.notes_outlined),
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 100,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerNomeLivro,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                helperText: "* Obrigatório",
              ),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Autor".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline_outlined,
            ),
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 75,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: customControllerAutor,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Nº de Páginas".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(Icons.library_books_outlined),
            title: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}'))
              ],
              minLines: 1,
              maxLines: 2,
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              controller: customControllerPaginas,
              onEditingComplete: () => node.nextFocus(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Capa".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(0, 52, 0, 0),
              child: Icon(Icons.image_outlined),
            ),
            title: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey[800]!.withOpacity(0.9),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Colors.grey[800]!,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        child: capa == null
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                width: 70,
                                height: 105,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  capa!,
                                  width: 70,
                                  height: 105,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 175,
                            height: 40,
                            child: TextButton(
                              onPressed: pickGallery,
                              child: Text(
                                "Selecionar Capa",
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Theme.of(context).cardTheme.color,
                                onPrimary: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          capa != null
                              ? SizedBox(
                                  height: 20,
                                )
                              : SizedBox.shrink(),
                          capa != null
                              ? Container(
                                  width: 175,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: removerCapa,
                                    child: Text(
                                      "Remover Capa",
                                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary:
                                          Theme.of(context).cardTheme.color,
                                      onPrimary: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
