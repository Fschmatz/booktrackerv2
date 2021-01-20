import 'dart:typed_data';

class Livro{

  int id;
  String nome;
  int numPaginas;
  String autor;
  int lido;
  Uint8List capa;

  Livro({this.id, this.nome,this.numPaginas,this.autor,this.lido,this.capa});

  int get getId{
    return id;
  }

  String get getNome{
    return nome;
  }

  int get getNumPaginas{
    return numPaginas;
  }

  String get getAutor{
    return autor;
  }

  int get getLido{
    return lido;
  }
}