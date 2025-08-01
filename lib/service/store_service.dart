import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadLivros(int pagina) async {
    await store.dispatch(LoadListLivroAction(pagina));
  }
}
