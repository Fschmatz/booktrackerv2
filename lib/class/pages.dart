class Pages {

  final int id;
  final String nome;

  Pages({this.id, this.nome});

  List<Pages> listPages = [];

  List<Pages> getListPages() {
    listPages.add(new Pages(id: 0, nome: 'Para Ler'));
    listPages.add(new Pages(id: 1, nome: 'Lendo'));
    listPages.add(new Pages(id: 2, nome: 'Lidos'));

    return listPages;
  }
}
