import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../service/livro_service.dart';
import '../widgets/livro_form.dart';

class NovoLivro extends StatefulWidget {
  NovoLivro({
    Key? key,
  }) : super(key: key);

  @override
  State<NovoLivro> createState() => _NovoLivroState();
}

class _NovoLivroState extends State<NovoLivro> {
  BorderRadius _capaBorder = BorderRadius.circular(12);
  int _situacaoLivroSelecionado = 1;
  TextEditingController _controllerNomeLivro = TextEditingController();
  TextEditingController _controllerPaginas = TextEditingController();
  TextEditingController _controllerAutor = TextEditingController();
  bool _nomeValido = true;
  final _imagePicker = ImagePicker();
  Uint8List? _capa;

  pickGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List? compressedFile = await FlutterImageCompress.compressWithFile(pickedFile!.path, quality: 90, minWidth: 325, minHeight: 475);

    if (compressedFile == null) {
      return 0;
    } else {
      setState(() {
        _capa = compressedFile;
      });
    }
  }

  void _inserir() async {
    await LivroService()
        .inserir(_controllerNomeLivro.text, _controllerPaginas.text, _controllerAutor.text, _situacaoLivroSelecionado, _capa == null ? null : _capa);
  }

  bool validarTextFields() {
    if (_controllerNomeLivro.text.isEmpty) {
      _nomeValido = false;
      return false;
    }
    return true;
  }

  void removerCapa() {
    setState(() {
      _capa = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Livro'),
      ),
      body: LivroForm(
        capa: _capa,
        capaBorder: _capaBorder,
        onPickCapa: pickGallery,
        onRemoveCapa: removerCapa,
        situacaoSelecionada: _situacaoLivroSelecionado,
        onSituacaoChanged: (v) => setState(() => _situacaoLivroSelecionado = v),
        nomeController: _controllerNomeLivro,
        autorController: _controllerAutor,
        paginasController: _controllerPaginas,
        nomeValido: _nomeValido,
        onSalvar: () {
          if (validarTextFields()) {
            _inserir();
            Navigator.pop(context);
          }
        },
        onEditingComplete: () => node.nextFocus(),
      ),
    );
  }
}
