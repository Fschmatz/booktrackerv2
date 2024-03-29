import 'dart:typed_data';

class Livro{

  int id;
  String nome;
  int? numPaginas;
  String? autor;
  // 0 = lendo, 1 = para ler, 2 = lido
  int? lido;
  Uint8List? capa;

  Livro({required this.id,required this.nome, this.numPaginas, this.autor, this.lido,this.capa});

  int get getId{
    return id;
  }

  String get getNome{
    return nome;
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['idLivro'] as int,
      nome: map['nome'] as String,
      numPaginas: map['numPaginas'] as int?,
      autor: map['autor'] as String?,
      lido: map['lido'] as int?,
      capa: map['capa'] as Uint8List?,
    );
  }
}