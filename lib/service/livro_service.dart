import 'package:booktrackerv2/service/store_service.dart';

import '../class/livro.dart';
import '../db/livro_dao.dart';

class LivroService extends StoreService {
  final dbLivro = LivroDao.instance;

  Future<List<Livro>> queryAllByStateAndConvertToList(int stateValue) async {
    var resp = await dbLivro.queryAllLivrosByEstado(stateValue);

    return resp.isNotEmpty ? resp.map((map) => Livro.fromMap(map)).toList() : [];
  }
}
