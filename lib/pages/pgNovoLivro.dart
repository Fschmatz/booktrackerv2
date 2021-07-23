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

  var _tapPosition;

  _showPopupMenuRemoverCapa() async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Theme.of(context).bottomAppBarColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(value: 1, child: Text("Remover Capa",style: TextStyle(color: Theme.of(context).textTheme.headline6!.color))),
      ],
      elevation: 2.0,
    ).then((value) => {
          if (value == 1)
            {
              setState(() {
                capa!.writeAsStringSync('');
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
              maxLength: 75,
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
              maxLength: 50,
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
                FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\d{0,2}'))
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
              padding: const EdgeInsets.fromLTRB(0, 38, 0, 0),
              child: Icon(Icons.image_outlined),
            ),
            title: Card(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                ),
                elevation: 0,
                child: InkWell(
                  onTap: pickGallery,
                  onTapDown: _storePosition,
                  onLongPress: _showPopupMenuRemoverCapa,
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 3, 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          const SizedBox(
                            width: 1,
                          ),
                          Text(
                            "Selecionar Capa",
                            style: TextStyle(fontSize: 16,color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                        ]),
                  ),
                )),
          ),

          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
