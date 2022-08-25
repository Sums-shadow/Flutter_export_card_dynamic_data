
import 'package:sample/models/personne.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

class PersonneDb {
  static final PersonneDb _instance = new PersonneDb.internal();
  factory PersonneDb() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();

    return _db!;
  }

  PersonneDb.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "maindb.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

/////////////////////////////////// Base de données créée /////////////////////////////
  /*
  
     id | username | password
     ------------------------
     1  | Paulo    | paulo
     2  | James    | bond

   */
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE ${TablePersonne.tablePersonne}(${TablePersonne.id} TEXT PRIMARY KEY, ${TablePersonne.prenom} TEXT,${TablePersonne.nom} TEXT,${TablePersonne.sexe} TEXT)");
  
  }

//CRUD - CREATE, READ, UPDATE , DELETE
//////////////////////////////////////////////////////////////////////////////////////////////////////
  //Insertion
  Future<int> savepersonne(Personne personne) async {
    var dbClient = await db;
    int res =
        await dbClient.insert("${TablePersonne.tablePersonne}", personne.toMap());
    print('saved successed!!!!!!!');
    return res;
  }


  // Get Users
  Future<List> get_all_personnes() async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM ${TablePersonne.tablePersonne}");
    return result.toList();
  }
    Future<Personne> getUser(String id) async {
    var dbClient = await db;

    var result = await dbClient.rawQuery(
        "SELECT * FROM ${TablePersonne.tablePersonne} WHERE ${TablePersonne.id} = $id");
    if (result.length == 0) return Personne("", "", "", "");
     return new Personne.fromMap(result.first);
  }
  

  Future<int?> getCountpersonne() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT COUNT(*) FROM ${TablePersonne.tablePersonne}"));
  }



  Future<int> deletepersonne(int id) async {
    var dbClient = await db;

    return await dbClient.delete('${TablePersonne.tablePersonne}',
        where: "${TablePersonne.id} = ?", whereArgs: [id]);
  }

    Future<int> updatepersonne(Personne personne) async {
    var dbClient = await db;
    return await dbClient.update('${TablePersonne.tablePersonne}', personne.toMap(),
        where: "${TablePersonne.id} = ?", whereArgs: [personne.id]);
  }
 

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////

}
