
import 'package:sample/db/db.dart';

PersonneDb personneDb= new PersonneDb();

List<dynamic> allPersonnes = [];
Future getallPersonnes() async {
  allPersonnes.clear();
  allPersonnes = await personneDb.get_all_personnes();
}